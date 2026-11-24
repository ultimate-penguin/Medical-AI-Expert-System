# Common Lisp Medical AI Expert System (HMM + MDP)

A prototype medical decision-support model written in **Common Lisp** that takes observable symptoms (**fever**, **runny nose**, **headache**), estimates the patient's underlying state (**flu** vs. **allergy**) using a **Hidden Markov Model (HMM)**, and selects a treatment action (**provide flu medication** vs. **provide allergy medication**) using a **Markov Decision Process (MDP)** aimed at restoring the patient to a **healthy** state.


## Overview

1. **Symptom Observation (HMM Emissions):** Reads symptoms such as `fever`, `runny-nose`, and `headache` to infer the probability distribution over hidden health states (`flu` or `allergy`).
2. **State Estimation (Forward / Filtering Step):** Updates belief over the patient's true state across time steps using initial state probabilities, transition probabilities, and symptom emission likelihoods.
3. **Decision Making (MDP Policy / Value Iteration):** Evaluates treatment actions to maximize expected reward toward reaching and maintaining the `healthy` state.

---

## Model Formulation

### 1. Observations (Symptoms)
* `fever`
* `runny-nose`
* `headache`

### 2. Hidden / Decision States
* `flu`
* `allergy`
* `healthy` (goal state)

### 3. Actions & Transition Dynamics
<img width="747" height="511" alt="image" src="https://github.com/user-attachments/assets/224798d0-9593-4a54-a2e6-fa4cfeeeb25c" />

### 4. Reward 
● R(Healthy) = 1\
● R(Flu) = −1\
● R(Allergy) = −0.5\
● ϕ = 0.1

---

## Getting Started
git clone https://github.com/ultimate-penguin/Medical-AI-Expert-System.git

cd Medical-AI-Expert-System

sbcl --load expert.lisp\
(init-agent)

**example output**

<img width="682" height="107" alt="image" src="https://github.com/user-attachments/assets/24535b22-c133-43af-a490-9200f5a5fb29" />


---
**Author**

Ultimate Penguin

GitHub: https://github.com/ultimate-penguin


