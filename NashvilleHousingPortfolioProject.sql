	/*

	Cleaning Data in SQL Queries

	*/

	Select *
	from [ Portfolio Project].dbo.NashvilleHousing
	where PropertyAddress is null
	--------------------------------------------------------------------------------------------------------------------------

	-- Standardize Date Format

	Select SaleDate, convert(date,saledate)
	from [ Portfolio Project].dbo.NashvilleHousing

	--Update [ Portfolio Project].dbo.NashvilleHousing
	--Set SaleDate =convert(date,saledate)

	--Update [ Portfolio Project].dbo.NashvilleHousing
	--Set SaleDate =convert(date,saledate)
		
	-- If it doesn't Update properly We do Alter Table instead

	Alter Table [ Portfolio Project].dbo.NashvilleHousing 
	Add SaleDateConverted Date;

	Update [ Portfolio Project].dbo.NashvilleHousing
	SET SaleDateConverted = Convert(Date,SaleDate)

	Select SaleDateConverted
	from [ Portfolio Project].dbo.NashvilleHousing
	 --------------------------------------------------------------------------------------------------------------------------

	-- Populate Property Address data
	Select a.ParcelId, a.PropertyAddress,b.ParcelId, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
	from [ Portfolio Project].dbo.NashvilleHousing a
	join [ Portfolio Project].dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueId] <> b.[UniqueId]
	Where a.PropertyAddress is null

	Update a 
	Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	from [ Portfolio Project].dbo.NashvilleHousing a
	join [ Portfolio Project].dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueId] <> b.[UniqueId]
	Where a.PropertyAddress is null

	--------------------------------------------------------------------------------------------------------------------------

	-- Breaking out Address into Individual Columns (Address, City, State)
	Select PropertyAddress
	from [ Portfolio Project].dbo.NashvilleHousing
	Where PropertyAddress is null

	SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Addy,
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Town
	From [ Portfolio Project].dbo.NashvilleHousing


	Alter Table NashvilleHousing 
	Add PropAddress Nvarchar(255);

	Update [ Portfolio Project].dbo.NashvilleHousing
	SET PropAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

	Alter Table NashvilleHousing 
	Add PropCity Nvarchar(255);
			
	Update [ Portfolio Project].dbo.NashvilleHousing
	SET PropCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

	--------------------------------------------------------------------------------------------------------------------------

	Select *
	from [ Portfolio Project].dbo.NashvilleHousing


	Select OwnerAddress
	from [ Portfolio Project].dbo.NashvilleHousing


	Select 
	Parsename(Replace(OwnerAddress,',','.'),3),
	Parsename(Replace(OwnerAddress,',','.'),2),
	Parsename(Replace(OwnerAddress,',','.'),1)
	from [ Portfolio Project].dbo.NashvilleHousing

	Alter Table NashvilleHousing 
	Add Street Nvarchar(255);
	--------------------------------------------------------------------------------------------------------------------------
	Update [ Portfolio Project].dbo.NashvilleHousing
	SET Street = Parsename(Replace(OwnerAddress,',','.'),3)

	Alter Table NashvilleHousing 
	Add City Nvarchar(255);

	Update [ Portfolio Project].dbo.NashvilleHousing
	SET City = Parsename(Replace(OwnerAddress,',','.'),2)

	Alter Table NashvilleHousing 
	Add USstate Nvarchar(255);

	Update [ Portfolio Project].dbo.NashvilleHousing
	SET USstate = Parsename(Replace(OwnerAddress,',','.'),1)

	Select *
	from [ Portfolio Project].dbo.NashvilleHousing

	-- Change Y and N to Yes and No in "Sold as Vacant" field

	Select Distinct( SoldAsVacant ), count(SoldAsVacant)
	from [ Portfolio Project].dbo.NashvilleHousing
	group by SoldAsVacant
	order by 2

	Select SoldAsVacant
	, Case when SoldAsVacant = 'Y' THEN 'Yes'
		   when SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End
	From [ Portfolio Project].dbo.NashvilleHousing

	Update [ Portfolio Project].dbo.NashvilleHousing
	SET SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'Yes'
		   when SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End


	-- Two different methods

	Select SoldAsVacant 
	from [ Portfolio Project].dbo.NashvilleHousing
	where SoldAsVacant = 'Y' OR SoldAsVacant = 'N'


	Update [ Portfolio Project].dbo.NashvilleHousing
	SET SoldAsVacant = 'Yes'
	where SoldAsVacant = 'Y'

	Update [ Portfolio Project].dbo.NashvilleHousing
	SET SoldAsVacant = 'No'
	where SoldAsVacant = 'N'

	-----------------------------------------------------------------------------------------------------------------------------------------------------------

	-- Remove Duplicates
	--CTE

	With RowNumCTE As(
	Select *,
	ROW_NUMBER() over(Partition By ParcelID,PropertyAddress, SalePrice, SaleDate,LegalReference order by UniqueID) row_num
	from [ Portfolio Project].dbo.NashvilleHousing
	)
	Select*
	From RowNUMCTE
	Where row_num > 1
	order by ParcelID

	With RowNumCTE As(
	Select *,
	ROW_NUMBER() over(Partition By ParcelID,PropertyAddress, SalePrice, SaleDate,LegalReference order by UniqueID) row_num
	from [ Portfolio Project].dbo.NashvilleHousing
	)
	DELETE
	From RowNUMCTE
	Where row_num > 1


	---------------------------------------------------------------------------------------------------------

	-- Delete Unused Columns

	Select * 
	from [ Portfolio Project].dbo.NashvilleHousing

	Alter table [ Portfolio Project].dbo.NashvilleHousing
	DROP column OwnerAddress,TaxDistrict, PropertyAddress,SaleDate
