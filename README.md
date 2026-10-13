# Agentforce Service Agent (org export)

Salesforce project for one Agentforce agent, **Agentforce Service Agent**, exported from the
dev org `orgfarm-fd76ef85eb-dev-ed` on 13 Oct 2026 with the Metadata API (version 65.0).

It is a test fixture for TES-1651 (fill an agent profile from the customer's code): a repo that
looks like what a customer keeps for their own Agentforce agent. Safe to delete.

## What is in it

| Path under `force-app/main/default/` | What it is |
|---|---|
| `genAiPlannerBundles/Agentforce_Service_Agent/` | The agent's planner: its 9 topics with their scope and instructions, and its actions with their input and output schemas |
| `bots/Agentforce_Service_Agent/` | The bot record and its version (welcome and error dialogs, variables) |
| `flows/Get_Demo_Rich_Link.flow-meta.xml` | Custom flow behind the action "Get Demo Rich Link" |
| `flows/Create_Case_for_Agent.flow-meta.xml` | Custom flow behind the action "Create Case" |
| `flows/Agentforce_Voice_Inbound_Routing.flow-meta.xml` | Routing flow for inbound voice |
| `classes/GetDemoRichChoice.cls` | Apex class behind the action "Get Demo Rich Choice" |

## Added by hand: two topics that are not in the org

The export above matches what Salesforce reports for this agent, so a profile built from Salesforce already has all of it. To have something that exists only in the code, two topics were written by hand on 13 Oct 2026, in the same shape as the exported ones. They are not deployed to the org.

| Topic | Actions | Apex classes |
|---|---|---|
| Returns and Refunds | Check Return Eligibility, Create Return Request, Issue Refund | `CheckReturnEligibility`, `CreateReturnRequest`, `IssueRefund` |
| Loyalty Rewards | Get Loyalty Points Balance, Redeem Loyalty Points | `GetLoyaltyPointsBalance`, `RedeemLoyaltyPoints` |

Both are in the planner file `genAiPlannerBundles/Agentforce_Service_Agent/Agentforce_Service_Agent.genAiPlannerBundle`, with their scope and three instructions each. The Apex classes are illustrative; they use two custom fields (`Contact.Loyalty_Points__c`, `Case.Order__c`) that the org does not have.

## What is not in it

- The other agent of the org (eCommerce Order Status Assistant).
- The flows whose names start with `SvcCopilotTmpl__`. They belong to Salesforce's own template package and cannot be exported as source.
- Any credential. The export holds no tokens or passwords; the two `...@...ext` names in the bot file are Salesforce's internal bot users.
