USE [MerlinAgg]
GO

/****** Object:  Table [dbo].[Data]    Script Date: 08/06/2015 11:19:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Data](
	[UniversalDataID] [int] NOT NULL,
	[AllocationAreaTypeID] [tinyint] NOT NULL,
	[GenericAllocationAreaID] [int] NOT NULL,
	[DataLayerID] [tinyint] NOT NULL,
	[FishingEntityID] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[TaxonKey] [int] NOT NULL,
	[CatchAmount] [float] NOT NULL,
	[SectorTypeID] [tinyint] NOT NULL,
	[CatchTypeID] [tinyint] NOT NULL,
	[InputTypeID] [tinyint] NOT NULL,
	[UniqueAreaID_AutoGen] [int] NULL,
	[OriginalFishingEntityID] [int] NOT NULL,
	[UnitPrice] [float] NOT NULL CONSTRAINT [DF_Data_Price]  DEFAULT ((1466)),
 CONSTRAINT [PK_Data] PRIMARY KEY CLUSTERED 
(
	[UniversalDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[AllocationResult_EEZ](
	[UniversalDataID] [int] NOT NULL,
	[EEZID] [int] NOT NULL,
	[FaoAreaID] [tinyint] NOT NULL,
	[TotalCatch] [float] NULL
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[AllocationResult_Global](
	[UniversalDataID] [int] NOT NULL,
	[AreaID] [int] NOT NULL,
	[TotalCatch] [float] NULL
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[AllocationResult_LME](
	[UniversalDataID] [int] NOT NULL,
	[LMEID] [smallint] NULL,
	[DataLayerID] [tinyint] NOT NULL,
	[FishingEntityID] [int] NOT NULL,
	[InputTypeID] [tinyint] NOT NULL,
	[SectorTypeID] [tinyint] NOT NULL,
	[TaxonKey] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[TotalCatch] [float] NULL
) ON [PRIMARY]

GO

