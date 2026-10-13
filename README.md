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

## What is not in it

- The other agent of the org (eCommerce Order Status Assistant).
- The flows whose names start with `SvcCopilotTmpl__`. They belong to Salesforce's own template package and cannot be exported as source.
- Any credential. The export holds no tokens or passwords; the two `...@...ext` names in the bot file are Salesforce's internal bot users.
