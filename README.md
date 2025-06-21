# 🧹 Data Cleaning in SQL – Nashville Housing Dataset

This project focuses on cleaning and preparing real-world housing data using SQL. The goal was to transform a messy dataset into a clean and analysis-ready format by applying SQL best practices.

## 📁 Dataset
**Nashville Housing Data** – A public dataset containing information about property sales, ownership, and locations.

---

## 🛠 Key Tasks Completed

### 1. 📅 Date Formatting
- Converted `SaleDate` to proper `DATE` format using `CONVERT()`.
- Created a new column `SaleDateConverted` to store the cleaned dates.

### 2. 🏘 Handling Missing Property Addresses
- Identified `NULL` values in the `PropertyAddress` column.
- Used a **self-join** on `ParcelID` to fill missing values based on matching records.

### 3. 🔍 Splitting Address Data
- Used `SUBSTRING()` and `CHARINDEX()` to split `PropertyAddress` into:
  - `PropertySplitAddress`
  - `PropertySplitCity`
- Used `PARSENAME()` with `REPLACE()` to split `OwnerAddress` into:
  - `OwnerSplitAddress`
  - `OwnerSplitCity`
  - `OwnerSplitCountry`

### 4. 🧼 Standardizing Text Values
- Cleaned the `SoldAsVacant` column by standardizing values (`Y/N` → `Yes/No`) using `CASE`.

### 5. 🗑 Removing Duplicates
- Used a **CTE with `ROW_NUMBER()`** to find duplicate rows.
- Deleted duplicates based on a combination of key columns (`ParcelID`, `PropertyAddress`, `SaleDate`, etc.).

### 6. 🧹 Dropping Unnecessary Columns
- Removed irrelevant or redundant columns such as:
  - `OwnerAddress`
  - `TaxDistrict`
  - Original `PropertyAddress`
  - `SaleDate`

---

## 💡 Tools & Skills Used
- Microsoft SQL Server
- SQL techniques: `CONVERT()`, `ISNULL()`, `PARSENAME()`, `JOIN`, `ROW_NUMBER()`, `CTE`, `CASE`, `ALTER TABLE`, `DELETE`, `UPDATE`

---


## 🙋‍♀️ About Me

Hi, I'm **Ciui Lidia Bianca**, a data enthusiast passionate about turning raw data into actionable insights using tools like SQL, Power BI, Excel, and Tableau.  
Feel free to [connect with me on LinkedIn]( https://www.linkedin.com](https://www.linkedin.com/in/ciui-lidia-4675b0245/ ) or check out more on my [portfolio website](https://your-portfolio-link.com).

---

## 📁 Folder Structure
```bash
data-cleaning-sql/
│
├── sql/
│   └── data_cleaning_script.sql
│
├── outputs/
│   └── cleaned_sample_preview.xlsx
│
└── README.md

---
