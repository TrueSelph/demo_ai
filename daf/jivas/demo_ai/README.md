# Demo AI Agent

This repository contains the **Demo AI**, a demonstration JIVAS AI agent designed to illustrate the capabilities and fundamental interactions of AI-driven components within the JIVAS ecosystem. Built upon the JIVAS platform, the Demo AI showcases interactive and configurable AI features utilizing advanced language models, making it an ideal starting point for exploring and experimenting with AI interactions and agent-based solutions.

---

## Package Information

- **Name:** `jivas/demo_ai`
- **Author:** `V75 Inc.`
- **Version:** `0.0.3`
- **Type:** `daf`

## Description

The **Demo AI** package provides a straightforward demonstration AI agent showcasing fundamental JIVAS interactions, facilitating intuitive and familiar engagement with users. It seamlessly integrates multiple specialized interaction actions, enabling enriched conversational experiences through configuration-driven, persona-aware interactions powered by leading-edge AI models.

---

## Dependencies

- **Jivas:** `^2.0.0`

---

## Included Actions

The package includes the following configured actions:

| Action Name | Version | Description | Enabled |
|-------------|---------|-------------|---------|
| `jivas/agent_utils_action` | `0.0.1` | Utilities and helper functionalities required for agents within JIVAS. | ✅ |
| `jivas/intro_interact_action` | `0.0.1` | Provides initial onboarding interaction logic and capabilities. | ✅ |
| `jivas/persona_interact_action` | `0.0.1` | Supports interactions with a persona-driven conversational methodology. | ✅ |
| `jivas/langchain_model_action` | `0.0.1` | Powers interactions through LangChain integration and advanced language model (`gpt-4o`) support. | ✅ |

---

## Model Configuration

**Demo AI** utilizes the Langchain Model integration (`jivas/langchain_model_action`). After installing, you **must configure your model API key**:

- **Model Type:** `gpt-4o`
- **Action to Configure:** `LangchainModelAction`

**To set your API key:**

1. Navigate to the package's configuration panel in your JIVAS interface.
2. Locate `LangchainModelAction` configuration.
3. Enter your API key appropriately to enable model-driven interactions.

---

## Getting Started

1. **Install the Package**:  
   Via your JIVAS marketplace or directly through your package management interface.

2. **Configure API Key**:  
   As described above, configure your Langchain model using your provided API key.

3. **Activate the Agent**:  
   Activate and initiate interactions within your JIVAS environment.

---

## Use Cases

- Demonstration of basic to advanced AI interaction techniques.
- Exploration of persona-driven conversational agents.
- Learning environment for AI agent configuration and deployment within JIVAS.

---

## Author and Support

Developed and maintained by **V75 Inc.** for the JIVAS platform. For support, issues, and enhancements, please reach out directly to V75 Inc. support channels or through this repository's issue tracker.

---

© 2024 V75 Inc. All Rights Reserved.