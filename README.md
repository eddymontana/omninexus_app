# OMNINEXUS AI | Agentic Command Center 🚀

**OmniNexus** is a high-performance, agentic desktop interface built for the 2026 Google AI Hackathon. It transforms unstructured natural language into structured, actionable data using the **Gemini 3 Flash** model.

## 🧠 The Tech Stack
- **Frontend:** Flutter (Windows Desktop) with Glassmorphic UI.
- **Intelligence:** Google Gemini 3 Flash (via `google_generative_ai`).
- **Orchestration:** Make.com (Middleware) & Custom Dart Orchestrator.
- **Data Sink:** Google Sheets (Persistence) & Gmail (High-Priority Alerts).

## 🛠️ Key Technical Features

### 1. Agentic Tool Calling
Unlike simple chatbots, OmniNexus uses **Function Calling**. When a user reports a bug or task, the AI reasons through the priority level and autonomously triggers a `log_to_database` call.

### 2. Real-time Multi-Channel Sync
The system utilizes a custom `AIOrchestrator` to bypass protocol signatures and ensure reliable delivery to a Webhook. One single command from the user results in:
- A new entry in the **Audit Trail** (Google Sheets).
- A **High-Priority Email** notification (via filtered Gmail automation).

### 3. Glassmorphic "Nexus" UI
A specialized UI/UX featuring:
- **Typewriter Effect:** Simulates real-time AI "thought" processing.
- **Backdrop Blur:** A modern, high-end "Glass" aesthetic for a Command Center feel.

## 📈 System Architecture
1. **User Input:** Unstructured text (e.g., "Log a high priority bug").
2. **Gemini 3 Flash:** Parses intent and extracts structured JSON parameters.
3. **Flutter Logic:** Executes tool call via HTTP POST to Make.com Webhook.
4. **Make.com:** Decouples the AI from the API, routing data to Sheets and Gmail.

---
*Developed by an AI/ML Engineer & Full-Stack Developer for the 2026 Google AI Hackathon.*
