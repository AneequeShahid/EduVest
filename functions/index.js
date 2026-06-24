// functions/index.js
// Deploy with: firebase deploy --only functions
//
// Requires:
//   cd functions && npm install firebase-functions firebase-admin
//   firebase use <your-project-id>

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

// =============================================================================
// Cloud Function 1: aggregateMonthlyInsights
// Trigger: every time a new expense document is created
// Action:  queries all expenses for the current month, computes totals,
//          and writes an insights document that InsightsPage reads from.
// =============================================================================
exports.aggregateMonthlyInsights = functions.firestore
  .document("users/{uid}/expenses/{expenseId}")
  .onCreate(async (snap, context) => {
    const { uid } = context.params;

    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, "0");
    const monthKey = `${year}-${month}`;

    // Date range for current month
    const startOfMonth = new Date(year, now.getMonth(), 1);
    const endOfMonth = new Date(year, now.getMonth() + 1, 0, 23, 59, 59);

    try {
      // Query all expenses this month
      const snapshot = await db
        .collection("users")
        .doc(uid)
        .collection("expenses")
        .where("date", ">=", admin.firestore.Timestamp.fromDate(startOfMonth))
        .where("date", "<=", admin.firestore.Timestamp.fromDate(endOfMonth))
        .get();

      let totalSpent = 0;
      const categoryBreakdown = {};

      snapshot.forEach((doc) => {
        const data = doc.data();
        const amount = data.amount || 0;
        const category = data.category || "Other";
        totalSpent += amount;
        categoryBreakdown[category] = (categoryBreakdown[category] || 0) + amount;
      });

      // Simple financial score: higher score = lower spending vs history
      // Score 0–100: 100 means no spending, drops proportionally with spend
      const financialScore = Math.max(0, Math.round(100 - (totalSpent / 15)));

      // Monthly yield and risk profile (static heuristics — replace with real logic)
      const monthlyYield = totalSpent < 500 ? "+2.4%" : "+1.1%";
      const riskProfile = totalSpent < 300 ? "Conservative" : totalSpent < 800 ? "Moderate" : "Aggressive";

      await db
        .collection("users")
        .doc(uid)
        .collection("insights")
        .doc(monthKey)
        .set(
          {
            totalSpent,
            categoryBreakdown,
            financialScore,
            monthlyYield,
            riskProfile,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          },
          { merge: true }
        );

      console.log(`[aggregateMonthlyInsights] uid=${uid} month=${monthKey} totalSpent=${totalSpent}`);
    } catch (err) {
      console.error("[aggregateMonthlyInsights] Error:", err);
    }
  });

// =============================================================================
// Cloud Function 2: onExpenseCreated (Budget Alert)
// Trigger: every time a new expense document is created
// Action:  checks if monthly spending has reached 80% of budget limit.
//          If so — and no unread BUDGET_WARNING alert already exists —
//          writes an alert document to users/{uid}/alerts.
// =============================================================================
exports.onExpenseCreated = functions.firestore
  .document("users/{uid}/expenses/{expenseId}")
  .onCreate(async (snap, context) => {
    const { uid } = context.params;

    try {
      // Read current budget
      const budgetSnap = await db
        .collection("users")
        .doc(uid)
        .collection("budget")
        .doc("current")
        .get();

      if (!budgetSnap.exists) {
        console.log(`[onExpenseCreated] No budget document for uid=${uid}, skipping.`);
        return null;
      }

      const budget = budgetSnap.data();
      const monthlyLimit = budget.monthlyLimit || 0;
      const monthlySpent = budget.monthlySpent || 0;

      if (monthlyLimit === 0) return null;

      const usageRatio = monthlySpent / monthlyLimit;

      if (usageRatio < 0.8) {
        // Under threshold — no alert needed
        return null;
      }

      // Check for an existing unread BUDGET_WARNING to avoid duplicates
      const existingAlerts = await db
        .collection("users")
        .doc(uid)
        .collection("alerts")
        .where("type", "==", "BUDGET_WARNING")
        .where("read", "==", false)
        .limit(1)
        .get();

      if (!existingAlerts.empty) {
        console.log(`[onExpenseCreated] Unread BUDGET_WARNING already exists for uid=${uid}, skipping.`);
        return null;
      }

      // Write new alert
      const pct = Math.round(usageRatio * 100);
      await db
        .collection("users")
        .doc(uid)
        .collection("alerts")
        .add({
          type: "BUDGET_WARNING",
          message: `You've used ${pct}% of your monthly budget. Consider reviewing your spending.`,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          read: false,
        });

      console.log(`[onExpenseCreated] BUDGET_WARNING written for uid=${uid} at ${pct}% usage.`);
    } catch (err) {
      console.error("[onExpenseCreated] Error:", err);
    }
  });
