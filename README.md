# User-Based Collaborative Filtering using KNN (R) - IR MSc Web Intelligence

## Author
* **Ioannis Manolas**

---

## Assignment Specification

Implement a user-based collaborative filtering recommendation system using the K-Nearest Neighbors (KNN) algorithm in R[cite: 7]. The system processes user movie ratings datasets (`u_data.csv` and `nu_data.csv`) to perform the following tasks[cite: 7]:

1. **Correlation Computation:** Calculate similarity between new users and existing users using the **Pearson correlation coefficient**[cite: 7].
2. **Nearest Neighbors Selection:** Identify the top $K$ nearest neighbors ($K=3$) for each new user based on correlation scores[cite: 7].
3. **Rating Prediction:** Predict missing ratings for unrated movies using a **Weighted Mean Average** based on neighbor ratings and correlation weights[cite: 7].
4. **Error Evaluation:** Compute absolute errors and the **Mean Absolute Error (MAE)** to evaluate prediction accuracy[cite: 7].
5. **Report Generation:** Export the combined dataset, correlation scores, predicted ratings, unrated movie tags, and evaluation metrics into a formatted Excel spreadsheet (`final_predicted_data.xlsx`)[cite: 7].

---

## Solution Overview

The R script (`Code_KNN_3.R`) automates the entire collaborative filtering pipeline[cite: 7]:

### Key Processing Steps:
* **Data Transformation:** Transposes user and new-user matrices to align users as columns and movies as rows[cite: 7].
* **Similarity Metric:** Applies `cor()` with Pearson method and complete observations to evaluate user preference alignments[cite: 7].
* **KNN & Weighted Voting:** Extracts the top 3 correlated neighbors using `tail(order())` and calculates predicted ratings via `weighted.mean()`[cite: 7].
* **Performance Evaluation:** Calculates absolute error vectors and MAE for both target users (`NU1` and `NU2`)[cite: 7].
* **Excel Export:** Binds initial data, correlation coefficients, calculated ratings, and MAE summaries using `openxlsx` and `qpcR` utilities[cite: 7].

### R Packages Used:
* **`openxlsx`**: For writing structured data directly to `.xlsx` files[cite: 7].
* **`dplyr`**: For data manipulation and handling coalesced values[cite: 7].
* **`qpcR`**: For advanced data frame binding with mismatched row/column lengths (`cbind.na`, `rbind.na`)[cite: 7].

---

## Getting Started

### Prerequisites
Ensure you have R and RStudio installed, then run the package installation command:
```R
install.packages(c("openxlsx", "dplyr", "qpcR"))