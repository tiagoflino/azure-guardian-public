let
    Source = Sql.Database("aoedevgithub-sql.database.windows.net", "azureoptimization", [Query="EXEC GetRecommendations", CommandTimeout=#duration(0, 2, 0, 0)]),
    #"Parsed JSON Tags" = Table.TransformColumns(Source,{{"Tags", Json.Document}}),
    #"Expanded Tags" = Table.ExpandRecordColumn(#"Parsed JSON Tags", "Tags", {"environment", "costcenter"}, {"Tags.Environment", "Tags.CostCenter"}),
    #"Trimmed Text" = Table.TransformColumns(#"Expanded Tags",{{"Tags.Environment", Text.Trim, type text}, {"Tags.CostCenter", Text.Trim, type text}}),
    #"Duplicated AdditionalInfo" = Table.DuplicateColumn(#"Trimmed Text","AdditionalInfo", "AddInfoJSON"),
    #"Parsed JSON AdditionalInfo" = Table.TransformColumns(#"Duplicated AdditionalInfo",{{"AdditionalInfo", Json.Document}}),
    #"Expanded AdditionalInfo" = Table.ExpandRecordColumn(#"Parsed JSON AdditionalInfo", "AdditionalInfo", {"BelowNetworkThreshold", "SupportsDataDisksCount", "MetricIOPS", "SupportsIOPS", "BelowMemoryThreshold", "currentSku", "targetSku", "SupportsNICCount", "DataDiskCount", "MetricMemoryPercentage", "MetricNetworkMbps", "MetricMiBps", "SupportsMiBps", "BelowCPUThreshold", "NicCount", "MetricCPUPercentage", "annualSavingsAmount", "savingsCurrency", "savingsAmount", "CostsAmount", "reservationType", "vmSize", "DiskType", "DiskSizeGB", "MaxMemoryP95", "MaxCpuP95", "MaxTotalNetworkP95", "DeploymentModel", "scope", "region", "qty", "displaySKU", "term"}, {"AddInfo.BelowNetworkThreshold", "AddInfo.SupportsDataDisksCount", "AddInfo.MetricIOPS", "AddInfo.SupportsIOPS", "AddInfo.BelowMemoryThreshold", "AddInfo.currentSku", "AddInfo.targetSku", "AddInfo.SupportsNICCount", "AddInfo.DataDiskCount", "AddInfo.MetricMemoryPercentage", "AddInfo.MetricNetworkMbps", "AddInfo.MetricMiBps", "AddInfo.SupportsMiBps", "AddInfo.BelowCPUThreshold", "AddInfo.NicCount", "AddInfo.MetricCPUPercentage", "AddInfo.annualSavingsAmount", "AddInfo.savingsCurrency", "AddInfo.savingsAmount", "AddInfo.CostsAmount", "AddInfo.reservationType", "AddInfo.vmSize", "AddInfo.DiskType", "AddInfo.DiskSizeGB", "AddInfo.MaxMemoryP95", "AddInfo.MaxCpuP95", "AddInfo.MaxTotalNetworkP95", "AddInfo.DeploymentModel", "AddInfo.Scope", "AddInfo.Region", "AddInfo.Quantity", "AddInfo.ReservationSKU", "AddInfo.Term"}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Expanded AdditionalInfo", "AddInfo.BelowNetworkThreshold", Splitter.SplitTextByDelimiter(":", QuoteStyle.None), {"AddInfo.BelowNetworkThreshold.1", "AddInfo.BelowNetworkThreshold.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"AddInfo.BelowNetworkThreshold.1", type text}, {"AddInfo.BelowNetworkThreshold.2", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"AddInfo.BelowNetworkThreshold.2", "AddInfo.BelowNetworkThresholdDetails"}, {"AddInfo.BelowNetworkThreshold.1", "AddInfo.BelowNetworkThresholdResult"}}),
    #"Split Column by Delimiter1" = Table.SplitColumn(#"Renamed Columns", "AddInfo.SupportsDataDisksCount", Splitter.SplitTextByDelimiter(":", QuoteStyle.None), {"AddInfo.SupportsDataDisksCount.1", "AddInfo.SupportsDataDisksCount.2"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter1",{{"AddInfo.SupportsDataDisksCount.1", type logical}, {"AddInfo.SupportsDataDisksCount.2", type text}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Changed Type1",{{"AddInfo.SupportsDataDisksCount.1", "AddInfo.SupportsDataDisksCountResult"}, {"AddInfo.SupportsDataDisksCount.2", "AddInfo.SupportsDataDisksCountDetails"}}),
    #"Split Column by Delimiter2" = Table.SplitColumn(#"Renamed Columns1", "AddInfo.SupportsIOPS", Splitter.SplitTextByDelimiter(":", QuoteStyle.None), {"AddInfo.SupportsIOPS.1", "AddInfo.SupportsIOPS.2"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Split Column by Delimiter2",{{"AddInfo.SupportsIOPS.1", type text}, {"AddInfo.SupportsIOPS.2", type text}}),
    #"Renamed Columns2" = Table.RenameColumns(#"Changed Type2",{{"AddInfo.SupportsIOPS.1", "AddInfo.SupportsIOPSResult"}, {"AddInfo.SupportsIOPS.2", "AddInfo.SupportsIOPSDetails"}}),
    #"Split Column by Delimiter3" = Table.SplitColumn(#"Renamed Columns2", "AddInfo.BelowMemoryThreshold", Splitter.SplitTextByDelimiter(":", QuoteStyle.None), {"AddInfo.BelowMemoryThreshold.1", "AddInfo.BelowMemoryThreshold.2"}),
    #"Changed Type3" = Table.TransformColumnTypes(#"Split Column by Delimiter3",{{"AddInfo.BelowMemoryThreshold.1", type text}, {"AddInfo.BelowMemoryThreshold.2", type text}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Changed Type3",{{"AddInfo.BelowMemoryThreshold.1", "AddInfo.BelowMemoryThresholdResult"}, {"AddInfo.BelowMemoryThreshold.2", "AddInfo.BelowMemoryThresholdDetails"}}),
    #"Split Column by Delimiter4" = Table.SplitColumn(#"Renamed Columns3", "AddInfo.SupportsNICCount", Splitter.SplitTextByDelimiter(":", QuoteStyle.None), {"AddInfo.SupportsNICCount.1", "AddInfo.SupportsNICCount.2"}),
    #"Changed Type4" = Table.TransformColumnTypes(#"Split Column by Delimiter4",{{"AddInfo.SupportsNICCount.1", type logical}, {"AddInfo.SupportsNICCount.2", type text}}),
    #"Renamed Columns4" = Table.RenameColumns(#"Changed Type4",{{"AddInfo.SupportsNICCount.1", "AddInfo.SupportsNICCountResult"}, {"AddInfo.SupportsNICCount.2", "AddInfo.SupportsNICCountDetails"}}),
    #"Split Column by Delimiter5" = Table.SplitColumn(#"Renamed Columns4", "AddInfo.SupportsMiBps", Splitter.SplitTextByDelimiter(":", QuoteStyle.None), {"AddInfo.SupportsMiBps.1", "AddInfo.SupportsMiBps.2"}),
    #"Changed Type5" = Table.TransformColumnTypes(#"Split Column by Delimiter5",{{"AddInfo.SupportsMiBps.1", type text}, {"AddInfo.SupportsMiBps.2", type text}}),
    #"Renamed Columns5" = Table.RenameColumns(#"Changed Type5",{{"AddInfo.SupportsMiBps.1", "AddInfo.SupportsMiBpsResult"}, {"AddInfo.SupportsMiBps.2", "AddInfo.SupportsMiBpsDetails"}}),
    #"Split Column by Delimiter6" = Table.SplitColumn(#"Renamed Columns5", "AddInfo.BelowCPUThreshold", Splitter.SplitTextByDelimiter(":", QuoteStyle.None), {"AddInfo.BelowCPUThreshold.1", "AddInfo.BelowCPUThreshold.2"}),
    #"Changed Type6" = Table.TransformColumnTypes(#"Split Column by Delimiter6",{{"AddInfo.BelowCPUThreshold.1", type text}, {"AddInfo.BelowCPUThreshold.2", type text}}),
    #"Renamed Columns6" = Table.RenameColumns(#"Changed Type6",{{"AddInfo.BelowCPUThreshold.1", "AddInfo.BelowCPUThresholdResult"}, {"AddInfo.BelowCPUThreshold.2", "AddInfo.BelowCPUThresholdDetails"}}),
    #"Changed Type7" = Table.TransformColumnTypes(#"Renamed Columns6",{{"AddInfo.CostsAmount", type number}}, "en-US"),
	#"Changed Type8" = Table.TransformColumnTypes(#"Changed Type7",{{"AddInfo.savingsAmount", type number}}, "en-US"),
	#"Changed Type9" = Table.TransformColumnTypes(#"Changed Type8",{{"AddInfo.DiskSizeGB", Int64.Type}}),
	#"Changed Type10" = Table.TransformColumnTypes(#"Changed Type9",{{"AddInfo.MaxMemoryP95", Int64.Type}}),
	#"Changed Type11" = Table.TransformColumnTypes(#"Changed Type10",{{"AddInfo.MaxCpuP95", Int64.Type}}),
	#"Changed Type12" = Table.TransformColumnTypes(#"Changed Type11",{{"AddInfo.MaxTotalNetworkP95", Int64.Type}}),
	#"Changed Type13" = Table.TransformColumnTypes(#"Changed Type12",{{"AddInfo.annualSavingsAmount", type number}}, "en-US"),
	#"Changed Type14" = Table.TransformColumnTypes(#"Changed Type13",{{"AddInfo.MetricCPUPercentage", type number}}, "en-US"),
	#"Changed Type15" = Table.TransformColumnTypes(#"Changed Type14",{{"AddInfo.NicCount", Int64.Type}}),
	#"Changed Type16" = Table.TransformColumnTypes(#"Changed Type15",{{"AddInfo.DataDiskCount", Int64.Type}}),
	#"Changed Type17" = Table.TransformColumnTypes(#"Changed Type16",{{"AddInfo.MetricMiBps", type number}}, "en-US"),
	#"Changed Type18" = Table.TransformColumnTypes(#"Changed Type17",{{"AddInfo.MetricIOPS", type number}}, "en-US"),
	#"Changed Type19" = Table.TransformColumnTypes(#"Changed Type18",{{"AddInfo.MetricNetworkMbps", type number}}, "en-US"),
	#"Changed Type20" = Table.TransformColumnTypes(#"Changed Type19",{{"AddInfo.MetricMemoryPercentage", type number}}, "en-US")
in
    #"Changed Type20"