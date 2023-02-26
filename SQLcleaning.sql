/*
Data Cleaning project
*/

--Check that the data is okay 

--Select*
--From PortfolioProject..NashvilleHousing

--Standardize SaleDate Format

--Select SaleDate, Convert(Date, SaleDate) 
--From PortfolioProject..NashvilleHousing
--Order by SaleDate

--Update PortfolioProject..NashvilleHousing
--Set SaleDate = Convert(Date, SaleDate) 

--Alter Table PortfolioProject..NashvilleHousing
--Add SaleDateConverted Date;

--Select SaleDate, SaleDateConverted
--From PortfolioProject..NashvilleHousing

--Update PortfolioProject..NashvilleHousing
--Set SaleDateConverted = Convert(Date, SaleDate) 

--Populate Property Addess data (deal with Misssingness)

--Select *
--From PortfolioProject..NashvilleHousing
----Where PropertyAddress is Null
--Order by ParcelID

--Select A.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, isNull(A.PropertyAddress, b.PropertyAddress)
----isNull checks if the first cell is null, if it is, it populates it whith the second value or String
--From PortfolioProject..NashvilleHousing as A
--Join PortfolioProject..NashvilleHousing as B
--	on A.ParcelID = B.ParcelID
--	And a.[UniqueID ] <> B.[UniqueID ]
--Where a.PropertyAddress is Null

--Update A
--Set PropertyAddress = isNull(A.PropertyAddress, b.PropertyAddress)
--From PortfolioProject..NashvilleHousing as A
--Join PortfolioProject..NashvilleHousing as B
--	on A.ParcelID = B.ParcelID

--Breaking out address into individual columns (Adress, City, State)

--Select PropertyAddress
--From PortfolioProject..NashvilleHousing

--Select
--Substring(PropertyAddress, 1, CHARINDEX (',',PropertyAddress)-1) As Address,
----We want to look for position from where to start (1) in property address, and look for specific value (CharIndex)
--Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) As City
--From PortfolioProject..NashvilleHousing


--Alter Table PortfolioProject..NashvilleHousing
--Add Address nvarchar(255), City nvarchar (255);

--Select PropertyAddress, Address, City
--From PortfolioProject..NashvilleHousing

--Update PortfolioProject..NashvilleHousing
--Set Address= Substring(PropertyAddress, 1, CHARINDEX (',',PropertyAddress)-1)

--Update PortfolioProject..NashvilleHousing
--Set City= Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

--Now do the Owner Address

--Select OwnerAddress
--From PortfolioProject..NashvilleHousing

--Select
--PARSENAME(Replace(OwnerAddress, ',', '.'),3) as OwnerStreet,
--PARSENAME(Replace(OwnerAddress, ',', '.'),2) as OwnerCity,
--PARSENAME(Replace(OwnerAddress, ',', '.'),1) as OwnerState
----Parsename looks for periods to delimit information
----THerefore, Commas need to be replaced with periods
----Parsename works backwards
--From PortfolioProject..NashvilleHousing
--Where OwnerAddress is not Null

--Alter Table PortfolioProject..NashvilleHousing
--Add OwnerStreet nvarchar(255), OwnerCity nvarchar (255), OwnerState nvarchar(255);

--Select OwnerStreet, OwnerCity, OwnerState
--From PortfolioProject..NashvilleHousing
--Where OwnerAddress is not Null

--Update PortfolioProject..NashvilleHousing
--Set OwnerStreet= PARSENAME(Replace(OwnerAddress, ',', '.'),3)

--Update PortfolioProject..NashvilleHousing
--Set OwnerCity= PARSENAME(Replace(OwnerAddress, ',', '.'),2)

--Update PortfolioProject..NashvilleHousing
--Set OwnerState= PARSENAME(Replace(OwnerAddress, ',', '.'),1)

--Change y and N to Yes and No in "Sold as vacant" fields

--Select Distinct(SoldAsVacant), Count(SoldASVacant)
--From PortfolioProject..NashvilleHousing
--Group by SoldAsVacant


--Select SoldAsVacant
--, Case
--	When SoldAsVacant = 'n' Then 'No'
--	When SoldAsVacant = 'y' then 'Yes'
--	Else SoldAsVacant 
--End as NewSoldAsVacant
--From PortfolioProject..NashvilleHousing

--Update NashvilleHousing
--Set SoldAsVacant = 
--Case
--	When SoldAsVacant = 'n' Then 'No'
--	When SoldAsVacant = 'y' then 'Yes'
--	Else SoldAsVacant 
--End

--Remove Duplication

--Create CTE that identifies duplicates (i.e., rows that are identical)
--With RowNumCTE As(
--Select *,
--ROW_NUMBER() Over(Partition By  ParcelID,
--								PropertyAddress,
--								SalePrice,
--								SaleDate,
--								LegalReference
--								Order by UniqueID) as row_num
--From PortfolioProject..NashvilleHousing
--)
--Select *
----Delete 
--From RowNumCTE
--Where row_num >1


--Delete unused Columns

Select*
From PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress