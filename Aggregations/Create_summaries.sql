USE [Merlin]
GO

---the Data/dims ---------------------------------------------------------------------------
delete from  MerlinAgg.dbo.Data

insert into MerlinAgg.dbo.Data
select d.*, 1466 as UnitPrice --- 1466 is the default price
from [dbo].[Data_verfied_L1L2_Ver37] d

insert into MerlinAgg.dbo.Data
select d.*, 1466 as UnitPrice
from [dbo].[Data_verified_layer3_all] d
Go

-- update price
update MerlinAgg.dbo.Data
set UnitPrice = p.Price
from MerlinAgg.dbo.Data d inner join merlin.dbo.Price p on d.[year] = p.[Year] AND d.[FishingEntityID] = p.FishingEntityID AND d.Taxonkey = p.Taxonkey
--------------------------------------------------------------------------------------------


---EEZs/High seas ---------------------------------------------------------------------------
USE Merlin
drop table MerlinAgg.dbo.AllocationResult_EEZ 
--L1L2 
SELECT distinct r.UniversalDataID, a.InheritedAtt_BelongsToReconstructionEEZID as EEZID, a.FaoAreaID, sum(r.AllocatedCatch) as TotalCatch
  into MerlinAgg.dbo.AllocationResult_EEZ
  FROM [dbo].[AllocationResult] r inner join [dbo].[AllocationSimpleArea] a on r.AllocationSimpleAreaID = a.AllocationSimpleAreaID
  group by r.UniversalDataID, a.InheritedAtt_BelongsToReconstructionEEZID , a.FaoAreaID

--L3
INSERT into MerlinAgg.dbo.AllocationResult_EEZ
SELECT distinct r.UniversalDataID, a.InheritedAtt_BelongsToReconstructionEEZID as EEZID, a.FaoAreaID, sum(r.AllocatedCatch) as TotalCatch 
  FROM [dbo].[AllocationResult_L3] r inner join [dbo].[AllocationSimpleArea] a on r.AllocationSimpleAreaID = a.AllocationSimpleAreaID
  group by r.UniversalDataID, a.InheritedAtt_BelongsToReconstructionEEZID , a.FaoAreaID

---------------------------------------------------------------------------------------------

-- LMEs--------------------------------------------------------------------------------------

USE Merlin
drop table MerlinAgg.dbo.AllocationResult_LME
--L1L2 

select r.UniversalDataID ,cr.AreaID As LMEID, d.DataLayerID, d.FishingEntityID, d.InputTypeID, d.SectorTypeID, d.TaxonKey, d.Year,  sum(r.AllocatedCatch*cr.WaterArea/(c.WaterArea)) as TotalCatch
into MerlinAgg.dbo.AllocationResult_LME
from SimpleAreaCellAssignmentRaw cr 
inner join Cell c on c.CellID = cr.CellID 
inner join AllocationResult r on r.CellID = cr.CellID
inner join data d on d.UniversalDataID = r.UniversalDataID
where MarineLayerID = 3 and c.WaterArea > 0
group by r.UniversalDataID, cr.AreaID, d.DataLayerID, d.FishingEntityID, d.InputTypeID, d.SectorTypeID, d.TaxonKey, d.Year


--L3
use Merlin
insert into MerlinAgg.dbo.AllocationResult_LME
select r.UniversalDataID ,cr.AreaID As LMEID, d.DataLayerID, d.FishingEntityID, d.InputTypeID, d.SectorTypeID, d.TaxonKey, d.Year,  sum(r.AllocatedCatch*cr.WaterArea/(c.WaterArea)) as TotalCatch
from SimpleAreaCellAssignmentRaw cr 
inner join Cell c on c.CellID = cr.CellID 
inner join AllocationResult_L3 r on r.CellID = cr.CellID
inner join [dbo].[Data_verified_layer3_all] d on d.UniversalDataID = r.UniversalDataID
where MarineLayerID = 3 and c.WaterArea > 0
group by r.UniversalDataID, cr.AreaID, d.DataLayerID, d.FishingEntityID, d.InputTypeID, d.SectorTypeID, d.TaxonKey, d.Year


-----------------------------------------------------------------------------------------------------------------------------------------------------

---Global -------------------------------------------------------------------------------------------------------------------------------------------

USE MerlinAgg
drop table MerlinAgg.dbo.AllocationResult_Global

SELECT [UniversalDataID]
      , 1 As AreaID, sum([TotalCatch]) As TotalCatch into MerlinAgg.dbo.AllocationResult_Global
  FROM [dbo].[AllocationResult_EEZ]
  where EEZID > 0
  group by [UniversalDataID]
  order by [UniversalDataID]

insert into MerlinAgg.dbo.AllocationResult_Global
SELECT [UniversalDataID]
      , 2 As AreaID, sum([TotalCatch]) As TotalCatch 
  FROM [dbo].[AllocationResult_EEZ]
  where EEZID = 0
  group by [UniversalDataID]
  order by [UniversalDataID]

-------------------------------------------------------------------------------------------------------------------------------------------------------
GO



