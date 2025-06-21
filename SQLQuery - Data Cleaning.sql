--Cleaning Data in SQL

-- 1. Changing the Date Format

--Checking the data

SELECT SaleDate, CONVERT(Date, SaleDate) AS SaleDateConverted
FROM SQLDataCleaning..NashvilleHousing;

--Changing the data format

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);



-- 2. Populate Property Address null data
		
--Identify NULL PropertyAddress rows

SELECT *
FROM SQLDataCleaning..NashvilleHousing
WHERE PropertyAddress IS NULL;

--Check for ParcelID consistency

SELECT *
FROM SQLDataCleaning..NashvilleHousing
ORDER BY ParcelID;	

--Preview join for update

SELECT a.ParcelID, a.PropertyAddress, 
       b.ParcelID, b.PropertyAddress, 
       ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM SQLDataCleaning..NashvilleHousing a
JOIN SQLDataCleaning..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--Update the NULL PropertyAddress values

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM SQLDataCleaning..NashvilleHousing a
JOIN SQLDataCleaning..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;



-- 3. Dividing the PropertyAddress Column into Individual Columns (Address, City) using SUBSTRING

--Inspecting for delimiter

SELECT PropertyAddress
FROM SQLDataCleaning..NashvilleHousing;

--Splitting the data into two columns

SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS PropertySplitAddress,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS PropertySplitCity
FROM SQLDataCleaning..NashvilleHousing;

--Adding and populating the new columns

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)
WHERE PropertyAddress IS NOT NULL;

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));



-- 4. Dividing the O	wnerAddress Column into Individual Columns (Address, City, Country) using PARSENAME

--Check the format first

SELECT OwnerAddress
FROM SQLDataCleaning..NashvilleHousing;

--Use PARSENAME to split the address

SELECT OwnerAddress,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerSplitAddress,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerSplitCity,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerSplitCountry
FROM SQLDataCleaning..NashvilleHousing;

--Create and populate new columns

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255),
    OwnerSplitCity NVARCHAR(255),
    OwnerSplitCountry NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    OwnerSplitCountry = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


-- 5. Standardized Text Values

--Inspect values and their frequency

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM SQLDataCleaning..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

--Preview the changes using CASE

SELECT SoldAsVacant,
    CASE 
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END
FROM SQLDataCleaning..NashvilleHousing;

--Update the column with standardized values

UPDATE NashvilleHousing
SET SoldAsVacant = 
    CASE 
        WHEN UPPER(SoldAsVacant) = 'Y' THEN 'Yes'
        WHEN UPPER(SoldAsVacant) = 'N' THEN 'No'
        ELSE SoldAsVacant
    END;



-- 6. Removing Duplicates in a CTE (original table won't be affected)

--cheching the data before deleting it

With RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID,
                            PropertyAddress,
                            SalePrice,
                            SaleDate,
                            LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM SQLDataCleaning..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1;

--delete the duplicate data

WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID,
                            PropertyAddress,
                            SalePrice,
                            SaleDate,
                            LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM SQLDataCleaning..NashvilleHousing
)
DELETE FROM SQLDataCleaning..NashvilleHousing
WHERE UniqueID IN (
    SELECT UniqueID
    FROM RowNumCTE
    WHERE row_num > 1
);



-- 7. Delete Unused Columns

--looking for irelevant data

SELECT *
FROM SQLDataCleaning..NashvilleHousing

--Removing the columns

ALTER TABLE SQLDataCleaning..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate