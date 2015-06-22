﻿DECLARE @CurrentMigration [nvarchar](max)

IF object_id('[dbo].[__MigrationHistory]') IS NOT NULL
    SELECT @CurrentMigration =
        (SELECT TOP (1) 
        [Project1].[MigrationId] AS [MigrationId]
        FROM ( SELECT 
        [Extent1].[MigrationId] AS [MigrationId]
        FROM [dbo].[__MigrationHistory] AS [Extent1]
        WHERE [Extent1].[ContextKey] = N'Ltd.NA.Emlak.Data.Migrations.Configuration'
        )  AS [Project1]
        ORDER BY [Project1].[MigrationId] DESC)

IF @CurrentMigration IS NULL
    SET @CurrentMigration = '0'

IF @CurrentMigration < '201506191908242_HouseMap'
BEGIN
    CREATE TABLE [dbo].[tbl_Houses] (
        [Id] [uniqueidentifier] NOT NULL,
        [Name] [nvarchar](max),
        [Description] [nvarchar](max),
        [FK_AddressId] [uniqueidentifier],
        [FK_CategoryId] [uniqueidentifier],
        CONSTRAINT [PK_dbo.tbl_Houses] PRIMARY KEY ([Id])
    )
    CREATE INDEX [IX_FK_AddressId] ON [dbo].[tbl_Houses]([FK_AddressId])
    CREATE INDEX [IX_FK_CategoryId] ON [dbo].[tbl_Houses]([FK_CategoryId])
    CREATE TABLE [dbo].[tbl_Address] (
        [Id] [uniqueidentifier] NOT NULL,
        [Address1] [nvarchar](max),
        [Address2] [nvarchar](max),
        [Number] [nvarchar](max),
        [City] [nvarchar](max),
        [Province] [nvarchar](max),
        [ZipCode] [nvarchar](max),
        [Country] [nvarchar](max),
        CONSTRAINT [PK_dbo.tbl_Address] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[tbl_Categories] (
        [Id] [uniqueidentifier] NOT NULL,
        [Entry] [nvarchar](max),
        [Description] [nvarchar](max),
        CONSTRAINT [PK_dbo.tbl_Categories] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[tbl_Person] (
        [Id] [uniqueidentifier] NOT NULL,
        [Age] [int] NOT NULL,
        [FirstName] [nvarchar](max),
        [LastName] [nvarchar](max),
        CONSTRAINT [PK_dbo.tbl_Person] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[tbl_Agent] (
        [Id] [uniqueidentifier] NOT NULL,
        [HouseInCharge_Id] [uniqueidentifier],
        [agentName] [nvarchar](max),
        [Description] [nvarchar](max),
        CONSTRAINT [PK_dbo.tbl_Agent] PRIMARY KEY ([Id])
    )
    CREATE INDEX [IX_Id] ON [dbo].[tbl_Agent]([Id])
    CREATE INDEX [IX_HouseInCharge_Id] ON [dbo].[tbl_Agent]([HouseInCharge_Id])
    CREATE TABLE [dbo].[tbl_Customer] (
        [Id] [uniqueidentifier] NOT NULL,
        [House_Id] [uniqueidentifier],
        [TcNo] [int] NOT NULL,
        [active] [bit] NOT NULL,
        [Rent] [bit] NOT NULL,
        CONSTRAINT [PK_dbo.tbl_Customer] PRIMARY KEY ([Id])
    )
    CREATE INDEX [IX_Id] ON [dbo].[tbl_Customer]([Id])
    CREATE INDEX [IX_House_Id] ON [dbo].[tbl_Customer]([House_Id])
    ALTER TABLE [dbo].[tbl_Houses] ADD CONSTRAINT [FK_dbo.tbl_Houses_dbo.tbl_Address_FK_AddressId] FOREIGN KEY ([FK_AddressId]) REFERENCES [dbo].[tbl_Address] ([Id])
    ALTER TABLE [dbo].[tbl_Houses] ADD CONSTRAINT [FK_dbo.tbl_Houses_dbo.tbl_Categories_FK_CategoryId] FOREIGN KEY ([FK_CategoryId]) REFERENCES [dbo].[tbl_Categories] ([Id])
    ALTER TABLE [dbo].[tbl_Agent] ADD CONSTRAINT [FK_dbo.tbl_Agent_dbo.tbl_Person_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[tbl_Person] ([Id])
    ALTER TABLE [dbo].[tbl_Agent] ADD CONSTRAINT [FK_dbo.tbl_Agent_dbo.tbl_Houses_HouseInCharge_Id] FOREIGN KEY ([HouseInCharge_Id]) REFERENCES [dbo].[tbl_Houses] ([Id])
    ALTER TABLE [dbo].[tbl_Customer] ADD CONSTRAINT [FK_dbo.tbl_Customer_dbo.tbl_Person_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[tbl_Person] ([Id])
    ALTER TABLE [dbo].[tbl_Customer] ADD CONSTRAINT [FK_dbo.tbl_Customer_dbo.tbl_Houses_House_Id] FOREIGN KEY ([House_Id]) REFERENCES [dbo].[tbl_Houses] ([Id])
    CREATE TABLE [dbo].[__MigrationHistory] (
        [MigrationId] [nvarchar](150) NOT NULL,
        [ContextKey] [nvarchar](300) NOT NULL,
        [Model] [varbinary](max) NOT NULL,
        [ProductVersion] [nvarchar](32) NOT NULL,
        CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY ([MigrationId], [ContextKey])
    )
    INSERT [dbo].[__MigrationHistory]([MigrationId], [ContextKey], [Model], [ProductVersion])
    VALUES (N'201506191908242_HouseMap', N'Ltd.NA.Emlak.Data.Migrations.Configuration',  0x1F8B0800000000000400E55CDB6EE3361ABE5F60DF41D055BB48AD2473B30DEC16198FD3353A3920CE148BBD3168897684EA54890A622CF6C9F6A28FB4AFB0A44EA428522225D9716630C020A1C88FFC8FFCF9F367FEF7DF3FA73FBFFA9EF102E3C40D8399793139370D18D8A1E306BB9999A2ED0F7F377FFEE9AF7F992E1CFFD5F8ADECF781F4C3238364663E23145D5956623F431F2413DFB5E33009B7686287BE059CD0BA3C3FFFD1BAB8B02086303196614C1FD300B93ECC7EC1BFCEC3C086114A81771B3AD04B8A76FC6595A11A77C08749046C38333F236772773D59F81EF87DF20920601AD79E0BF04256D0DB9A0608821001849779F525812B1487C16E15E106E03DED2388FB6D8197C062F957B4BB2A25E79784128B0E2CA1EC3441A1AF0978F1A1608DC50FEFC560B3621D66DE023319ED09D5190367E63FC29450CECF7435F762D28B672EEEE306936CD09921F874562904D61BF2EFCC98A71E4A63380B608A62E09D190FE9C673ED5FE1FE29FC1D06B320F53C768D7895F85BAD01373DC4610463B47F84DB62E54BC734ACFA388B1F580D63C6E464FD92BAF8E73B3C37D878B0D200AB7538F9BF04C06A840DC2346EC1EB6718ECD0F3CCC43F9AC68DFB0A9DB2A540FD12B8D87EF02014A79D937C82891DBB512EEFB1E7BA032FEE2E933037EBB5E3C430494CE3117AD9F7E4D98D7203CAC5BDAE7ADCC4A1FF187AA5F2941FD6AB308D6DC29F50F4F509C43B88D417340708EEC278DFB222DA855F52F945B2A6EAB36851538B1A49ABE9540CD1339E62D837683E05E5170737A162A2CB834F7497FA1B181F7C9A3956BC834F827F7D7103FBF00EEE5F6E34C79D0FCFB5108714F1D88C53760FD43BE9F98772DC37E820160790D731375865DD78C04224B3EB69463EEA1BD48BEB5DE52D9601FA70A90D70E3C6093A4AF4F6191C6422F5A0640703A41D929041A3EA95F11124B0E00009D80A856F651D20ABF88A43EC2CF65C06F36712740AC3DA4C0E6BAE1F8D6D059F1B01AEA8CFA028779E6912097234B7B162DC9BABD5937D170EF31EC046EE4BA5951F43CC681068A33C6686A989D1AE4C42252A19BF2EBA50FDA97F69A80EF759476BAE9324B4DD6C25ECFAAA33639DA845E018AD07482AE082865BAC1C6E84D501CF3D33FFD660930CB1A48141AC4E6D75CCF3C9E482A795A14A85D82AE06B5F5BF36C3A98DCC6799681A461E888048B1C956C89AD5E8B914BBE71A993DEE6E9BA583A8878CEC064EB93591B239ACAB5AA532D31D21109CE2D7C1E06083B6A18975B264060839D2F6987AFA208E30BFE986F0849B133F23410DC1544ACD1603BA41EA54E408305F5E1851D0B112A1BEFC0286CC3158250C3E940798061E441014219E573E319BE73DCA03936A68F3009C787E95D2EB55A33E5BBA58A51EA1883C1309F3F0AD4A953A69C725B46BAD8BDAA38D83EC4375C2A03C2AACD60F285315F93079D1E57D9E73284949ADBC28D362FDBC9D71EECE0A3972627DADCAF8A03D6A35FE26F87905E0651958BA5775B567EB9555E8259925BB0E92D88227C5C616EC58A1663955F89CD7F58E95F16F939866527823BA36AB5D54C288CF1918DFB4AD26E0ECCCEDBE596611A73C76F74E33714898F2D67ABED194D71959EB7EC4E7E2E0EE4FCE5E044A837948537982A1F2B7D4620E405DD1C975D49020FC4829CC73CF4523F90E54DDA46E7E760767CDEA28E503BE4B240B50F4DBCA9C53182E7B6D56037A7F9BCF094444BB79461D295EC900AF2958E3C8C84E96D088B415BB5912E8548975A5A57DC67D4F4AE685347C9AF2B588CBC451D81DE45B028B4551DA9BA6C6081AA460D9ACACB841A5965E3C95811139A0C332359B4A56047F2A18731A44553300B9958BE126759042E3A225E26E4E7FBED774D59E7E794EF7B885A947F3B9CA0B36B809A8BDB69D930730BC0A230CDEA5834CFCF42D1D6F155457F27CC322AFA42451B6F2D197B18B932897F1684693E7D43D677B065F2A79F80E4C30F23A33C8BCE8ECF5B34A45C64D16B222EDAD451F22C3A8B91B71CDF35D7CF7782730ACDE6749E466857A54307399F8AEE03F8944D93274A9A71F36B0924D211C2976A76DD851587F09E0BD35E0E3E5C3A6E96BA5D26E4AAA5BA665125973FC6F7D4049ADDEA5605DA77982EF019ACFECA50228DA60D7C86EED4D4414EF0607D10A6FB3A77717E80F2962D10414B46AFA71CEA582368494BFAF2A454A58BF0C1DAC2674355028AB2AF4ED420908138F1394443C6D00C714EF7F494A297323412C37C972AA4A912C45C22785A2465BBDF4C34B2B47917D3C8922C0EC9D0AEF609827EAE5CAB3FBCB9E7669156D9E11604EE1626282FCF302FCF2F2EB97717A7F306C24A12C71324B51B0F21EA123B423D5C1AB87FA410F313AF67EB923CDB803709C10B886DEC8CBEF3C1EBF72C52CFA2A84178F5B04A466DE31A791938F07566FE3B43B93296FF5CB34067C67D8C75EFCA3837FED36341ECC63E6C4514497D49DA2F0BDE9F36F225FE8334882FE31F04562FD51F04C596E30F02E24BEE07817165F5C328AC97CE6B60E997C7BF3F255FF4E4CDD83E57B7DCFCFD719A29FC7649EC31B4EC7B90B0F8D2EE43484A72907B1B6129EC84F2ED4F4940CD03D480B5F060436285462DFA7B3073F909EFABD69F51F466A0BEB045E67D3C55BDC47CE3EA23B0E5E5DDE3C72EE4AEA5BA752BAD8D46F95D9FA268ACC7302682071E3E402728C647E846CEFF21C6F1961B018F5B773383A0621E848F1522FFE5138C604034B14698CA445DF9F70A99B3D52E0E8C5FD15ECF6B6B579CBFA1E05BEA1BDE56F2EDC9F623883E4FBE123150A4357944B2CEC3C8F553B8968529549A65EDB3A01CBA2ECF3695A0D3B0384CAB8282F5D20E595DC3F8BAD172D9AE3CD9D19442EDC187A22177B8034DD98FE416D44DF5A87257B96139821654D9F76EEF2089430FE020E82B1A4E4F64CF6BDEAB9B68A91839214FA1F83A6A3C27A12DFFF7E82AB464DF76DB36BA067057565502917F04C08B50F0184CFE162CBF9C9A99CE869CB28A6319668BE4ED058F5E9D441AF8B4EE463283E653B27DEB4332D9242D0F8AF8794A1FD998A5FC209B43F2188DC76736D8C614CC3729BB76826A2CE124D43A85F3D0CF52A6553D8EFABE8ED3A5DACB81CE6765CD8743A7F5808ED7E27A3DF7DB90A7771E913E9DEB75A011462CCDFAE736C6340C8A2BD839D117848AF23C32A97D02D0B627847DE3D891F482F781CD3A9D937A50D95727C62453E3F164B316068739CC5F19C58156E2EE280429EF09A05D0B70AA3ECB601B969116B7A2B20B9790BD85083838FAB98E91BB0536C29F6DBC49647F65E637E0A5B8CBC2DF406719DCA7284A112619FA1BAFE66649BCD6367FF642B4BEE6E97D76CF908C41025EA68B4980F7C1C7D4F59C6ADD378284B204820482BF40DC9ECB121B1ADE4CF615D25D18280215ECABE2D727E8471E064BEE831520A973FDB57D49E067B803F6BE2C699283740BA2CEF6E92717EC62E02705061D8F7FC53AECF8AF3FFD1FC2F82C386C570000 , N'6.1.3-40302')
END

IF @CurrentMigration < '201506191910082_AddBlogUrl'
BEGIN
    INSERT [dbo].[__MigrationHistory]([MigrationId], [ContextKey], [Model], [ProductVersion])
    VALUES (N'201506191910082_AddBlogUrl', N'Ltd.NA.Emlak.Data.Migrations.Configuration',  0x1F8B0800000000000400E55CDB6EE3361ABE5F60DF41D055BB48AD2473B30DEC16198FD3353A3920CE148BBD3168897684EA54890A622CF6C9F6A28FB4AFB0A44EA428522225D9716630C020A1C88FFC8FFCF9F367FEF7DF3FA73FBFFA9EF102E3C40D8399793139370D18D8A1E306BB9999A2ED0F7F377FFEE9AF7F992E1CFFD5F8ADECF781F4C3238364663E23145D5956623F431F2413DFB5E33009B7686287BE059CD0BA3C3FFFD1BAB8B02086303196614C1FD300B93ECC7EC1BFCEC3C086114A81771B3AD04B8A76FC6595A11A77C08749046C38333F236772773D59F81EF87DF20920601AD79E0BF04256D0DB9A0608821001849779F525812B1487C16E15E106E03DED2388FB6D8197C062F957B4BB2A25E79784128B0E2CA1EC3441A1AF0978F1A1608DC50FEFC560B3621D66DE023319ED09D5190367E63FC29450CECF7435F762D28B672EEEE306936CD09921F874562904D61BF2EFCC98A71E4A63380B608A62E09D190FE9C673ED5FE1FE29FC1D06B320F53C768D7895F85BAD01373DC4610463B47F84DB62E54BC734ACFA388B1F580D63C6E464FD92BAF8E73B3C37D878B0D200AB7538F9BF04C06A840DC2346EC1EB6718ECD0F3CCC43F9AC68DFB0A9DB2A540FD12B8D87EF02014A79D937C82891DBB512EEFB1E7BA032FEE2E933037EBB5E3C430494CE3117AD9F7E4D98D7203CAC5BDAE7ADCC4A1FF187AA5F2941FD6AB308D6DC29F50F4F509C43B88D417340708EEC278DFB222DA855F52F945B2A6EAB36851538B1A49ABE9540CD1339E62D837683E05E5170737A162A2CB834F7497FA1B181F7C9A3956BC834F827F7D7103FBF00EEE5F6E34C79D0FCFB5108714F1D88C53760FD43BE9F98772DC37E820160790D731375865DD78C04224B3EB69463EEA1BD48BEB5DE52D9601FA70A90D70E3C6093A4AF4F6191C6422F5A0640703A41D929041A3EA95F11124B0E00009D80A856F651D20ABF88A43EC2CF65C06F36712740AC3DA4C0E6BAE1F8D6D059F1B01AEA8CFA028779E6912097234B7B162DC9BABD5937D170EF31EC046EE4BA5951F43CC681068A33C6686A989D1AE4C42252A19BF2EBA50FDA97F69A80EF759476BAE9324B4DD6C25ECFAAA33639DA845E018AD07482AE082865BAC1C6E84D501CF3D33FFD660930CB1A48141AC4E6D75CCF3C9E482A795A14A85D82AE06B5F5BF36C3A98DCC6799681A461E888048B1C956C89AD5E8B914BBE71A993DEE6E9BA583A8878CEC064EB93591B239ACAB5AA532D31D21109CE2D7C1E06083B6A18975B264060839D2F6987AFA208E30BFE986F0849B133F23410DC1544ACD1603BA41EA54E408305F5E1851D0B112A1BEFC0286CC3158250C3E940798061E441014219E573E319BE73DCA03936A68F3009C787E95D2EB55A33E5BBA58A51EA1883C1309F3F0AD4A953A69C725B46BAD8BDAA38D83EC4375C2A03C2AACD60F285315F93079D1E57D9E73284949ADBC28D362FDBC9D71EECE0A3972627DADCAF8A03D6A35FE26F87905E0651958BA5775B567EB9555E8259925BB0E92D88227C5C616EC58A1663955F89CD7F58E95F16F939866527823BA36AB5D54C288CF1918DFB4AD26E0ECCCEDBE596611A73C76F74E33714898F2D67ABED194D71959EB7EC4E7E2E0EE4FCE5E044A837948537982A1F2B7D4620E405DD1C975D49020FC4829CC73CF4523F90E54DDA46E7E760767CDEA28E503BE4B240B50F4DBCA9C53182E7B6D56037A7F9BCF094444BB79461D295EC900AF2958E3C8C84E96D088B415BB5912E8548975A5A57DC67D4F4AE685347C9AF2B588CBC451D81DE45B028B4551DA9BA6C6081AA460D9ACACB841A5965E3C95811139A0C332359B4A56047F2A18731A44553300B9958BE126759042E3A225E26E4E7FBED774D59E7E794EF7B885A947F3B9CA0B36B809A8BDB69D930730BC0A230CDEA5834CFCF42D1D6F155457F27CC322AFA42451B6F2D197B18B932897F1684693E7D43D677B065F2A79F80E4C30F23A33C8BCE8ECF5B34A45C64D16B222EDAD451F22C3A8B91B71CDF35D7CF7782730ACDE6749E466857A54307399F8AEE03F8944D93274A9A71F36B0924D211C2976A76DD851587F09E0BD35E0E3E5C3A6E96BA5D26E4AAA5BA665125973FC6F7D4049ADDEA5605DA77982EF019ACFECA50228DA60D7C86EED4D4414EF0607D10A6FB3A77717E80F2962D10414B46AFA71CEA582368494BFAF2A454A58BF0C1DAC2674355028AB2AF4ED420908138F1394443C6D00C714EF7F494A297323412C37C972AA4A912C45C22785A2465BBDF4C34B2B47917D3C8922C0EC9D0AEF609827EAE5CAB3FBCB9E7669156D9E11604EE1626282FCF302FCF2F2EB97717A7F306C24A12C71324B51B0F21EA123B423D5C1AB87FA410F313AF67EB923CDB803709C10B886DEC8CBEF3C1EBF72C52CFA2A84178F5B04A466DE31A791938F07566FE3B43B93296FF5CB34067C67D8C75EFCA3837FED36341ECC63E6C4514497D49DA2F0BDE9F36F225FE8334882FE31F04562FD51F04C596E30F02E24BEE07817165F5C328AC97CE6B60E997C7BF3F255FF4E4CDD83E57B7DCFCFD719A29FC7649EC31B4EC7B90B0F8D2EE43484A72907B1B6129EC84F2ED4F4940CD03D480B5F060436285462DFA7B3073F909EFABD69F51F466A0BEB045E67D3C55BDC47CE3EA23B0E5E5DDE3C72EE4AEA5BA752BAD8D46F95D9FA268ACC7302682071E3E402728C647E846CEFF21C6F1961B018F5B773383A0621E848F1522FFE5138C604034B14698CA445DF9F70A99B3D52E0E8C5FD15ECF6B6B579CBFA1E05BEA1BDE56F2EDC9F623883E4FBE123150A4357944B2CEC3C8F553B8968529549A65EDB3A01CBA2ECF3695A0D3B0384CAB8282F5D20E595DC3F8BAD172D9AE3CD9D19442EDC187A22177B8034DD98FE416D44DF5A87257B96139821654D9F76EEF2089430FE020E82B1A4E4F64CF6BDEAB9B68A91839214FA1F83A6A3C27A12DFFF7E82AB464DF76DB36BA067057565502917F04C08B50F0184CFE162CBF9C9A99CE869CB28A6319668BE4ED058F5E9D441AF8B4EE463283E653B27DEB4332D9242D0F8AF8794A1FD998A5FC209B43F2188DC76736D8C614CC3729BB76826A2CE124D43A85F3D0CF52A6553D8EFABE8ED3A5DACB81CE6765CD8743A7F5808ED7E27A3DF7DB90A7771E913E9DEB75A011462CCDFAE736C6340C8A2BD839D117848AF23C32A97D02D0B627847DE3D891F482F781CD3A9D937A50D95727C62453E3F164B316068739CC5F19C58156E2EE280429EF09A05D0B70AA3ECB601B969116B7A2B20B9790BD85083838FAB98E91BB0536C29F6DBC49647F65E637E0A5B8CBC2DF406719DCA7284A112619FA1BAFE66649BCD6367FF642B4BEE6E97D76CF908C41025EA68B4980F7C1C7D4F59C6ADD378284B204820482BF40DC9ECB121B1ADE4CF615D25D18280215ECABE2D727E8471E064BEE831520A973FDB57D49E067B803F6BE2C699283740BA2CEF6E92717EC62E02705061D8F7FC53AECF8AF3FFD1FC2F82C386C570000 , N'6.1.3-40302')
END

IF @CurrentMigration < '201506191911005_AddPostClass'
BEGIN
    INSERT [dbo].[__MigrationHistory]([MigrationId], [ContextKey], [Model], [ProductVersion])
    VALUES (N'201506191911005_AddPostClass', N'Ltd.NA.Emlak.Data.Migrations.Configuration',  0x1F8B0800000000000400E55CDB6EE3361ABE5F60DF41D055BB48AD2473B30DEC16198FD3353A3920CE148BBD3168897684EA54890A622CF6C9F6A28FB4AFB0A44EA428522225D9716630C020A1C88FFC8FFCF9F367FEF7DF3FA73FBFFA9EF102E3C40D8399793139370D18D8A1E306BB9999A2ED0F7F377FFEE9AF7F992E1CFFD5F8ADECF781F4C3238364663E23145D5956623F431F2413DFB5E33009B7686287BE059CD0BA3C3FFFD1BAB8B02086303196614C1FD300B93ECC7EC1BFCEC3C086114A81771B3AD04B8A76FC6595A11A77C08749046C38333F236772773D59F81EF87DF20920601AD79E0BF04256D0DB9A0608821001849779F525812B1487C16E15E106E03DED2388FB6D8197C062F957B4BB2A25E79784128B0E2CA1EC3441A1AF0978F1A1608DC50FEFC560B3621D66DE023319ED09D5190367E63FC29450CECF7435F762D28B672EEEE306936CD09921F874562904D61BF2EFCC98A71E4A63380B608A62E09D190FE9C673ED5FE1FE29FC1D06B320F53C768D7895F85BAD01373DC4610463B47F84DB62E54BC734ACFA388B1F580D63C6E464FD92BAF8E73B3C37D878B0D200AB7538F9BF04C06A840DC2346EC1EB6718ECD0F3CCC43F9AC68DFB0A9DB2A540FD12B8D87EF02014A79D937C82891DBB512EEFB1E7BA032FEE2E933037EBB5E3C430494CE3117AD9F7E4D98D7203CAC5BDAE7ADCC4A1FF187AA5F2941FD6AB308D6DC29F50F4F509C43B88D417340708EEC278DFB222DA855F52F945B2A6EAB36851538B1A49ABE9540CD1339E62D837683E05E5170737A162A2CB834F7497FA1B181F7C9A3956BC834F827F7D7103FBF00EEE5F6E34C79D0FCFB5108714F1D88C53760FD43BE9F98772DC37E820160790D731375865DD78C04224B3EB69463EEA1BD48BEB5DE52D9601FA70A90D70E3C6093A4AF4F6191C6422F5A0640703A41D929041A3EA95F11124B0E00009D80A856F651D20ABF88A43EC2CF65C06F36712740AC3DA4C0E6BAE1F8D6D059F1B01AEA8CFA028779E6912097234B7B162DC9BABD5937D170EF31EC046EE4BA5951F43CC681068A33C6686A989D1AE4C42252A19BF2EBA50FDA97F69A80EF759476BAE9324B4DD6C25ECFAAA33639DA845E018AD07482AE082865BAC1C6E84D501CF3D33FFD660930CB1A48141AC4E6D75CCF3C9E482A795A14A85D82AE06B5F5BF36C3A98DCC6799681A461E888048B1C956C89AD5E8B914BBE71A993DEE6E9BA583A8878CEC064EB93591B239ACAB5AA532D31D21109CE2D7C1E06083B6A18975B264060839D2F6987AFA208E30BFE986F0849B133F23410DC1544ACD1603BA41EA54E408305F5E1851D0B112A1BEFC0286CC3158250C3E940798061E441014219E573E319BE73DCA03936A68F3009C787E95D2EB55A33E5BBA58A51EA1883C1309F3F0AD4A953A69C725B46BAD8BDAA38D83EC4375C2A03C2AACD60F285315F93079D1E57D9E73284949ADBC28D362FDBC9D71EECE0A3972627DADCAF8A03D6A35FE26F87905E0651958BA5775B567EB9555E8259925BB0E92D88227C5C616EC58A1663955F89CD7F58E95F16F939866527823BA36AB5D54C288CF1918DFB4AD26E0ECCCEDBE596611A73C76F74E33714898F2D67ABED194D71959EB7EC4E7E2E0EE4FCE5E044A837948537982A1F2B7D4620E405DD1C975D49020FC4829CC73CF4523F90E54DDA46E7E760767CDEA28E503BE4B240B50F4DBCA9C53182E7B6D56037A7F9BCF094444BB79461D295EC900AF2958E3C8C84E96D088B415BB5912E8548975A5A57DC67D4F4AE685347C9AF2B588CBC451D81DE45B028B4551DA9BA6C6081AA460D9ACACB841A5965E3C95811139A0C332359B4A56047F2A18731A44553300B9958BE126759042E3A225E26E4E7FBED774D59E7E794EF7B885A947F3B9CA0B36B809A8BDB69D930730BC0A230CDEA5834CFCF42D1D6F155457F27CC322AFA42451B6F2D197B18B932897F1684693E7D43D677B065F2A79F80E4C30F23A33C8BCE8ECF5B34A45C64D16B222EDAD451F22C3A8B91B71CDF35D7CF7782730ACDE6749E466857A54307399F8AEE03F8944D93274A9A71F36B0924D211C2976A76DD851587F09E0BD35E0E3E5C3A6E96BA5D26E4AAA5BA665125973FC6F7D4049ADDEA5605DA77982EF019ACFECA50228DA60D7C86EED4D4414EF0607D10A6FB3A77717E80F2962D10414B46AFA71CEA582368494BFAF2A454A58BF0C1DAC2674355028AB2AF4ED420908138F1394443C6D00C714EF7F494A297323412C37C972AA4A912C45C22785A2465BBDF4C34B2B47917D3C8922C0EC9D0AEF609827EAE5CAB3FBCB9E7669156D9E11604EE1626282FCF302FCF2F2EB97717A7F306C24A12C71324B51B0F21EA123B423D5C1AB87FA410F313AF67EB923CDB803709C10B886DEC8CBEF3C1EBF72C52CFA2A84178F5B04A466DE31A791938F07566FE3B43B93296FF5CB34067C67D8C75EFCA3837FED36341ECC63E6C4514497D49DA2F0BDE9F36F225FE8334882FE31F04562FD51F04C596E30F02E24BEE07817165F5C328AC97CE6B60E997C7BF3F255FF4E4CDD83E57B7DCFCFD719A29FC7649EC31B4EC7B90B0F8D2EE43484A72907B1B6129EC84F2ED4F4940CD03D480B5F060436285462DFA7B3073F909EFABD69F51F466A0BEB045E67D3C55BDC47CE3EA23B0E5E5DDE3C72EE4AEA5BA752BAD8D46F95D9FA268ACC7302682071E3E402728C647E846CEFF21C6F1961B018F5B773383A0621E848F1522FFE5138C604034B14698CA445DF9F70A99B3D52E0E8C5FD15ECF6B6B579CBFA1E05BEA1BDE56F2EDC9F623883E4FBE123150A4357944B2CEC3C8F553B8968529549A65EDB3A01CBA2ECF3695A0D3B0384CAB8282F5D20E595DC3F8BAD172D9AE3CD9D19442EDC187A22177B8034DD98FE416D44DF5A87257B96139821654D9F76EEF2089430FE020E82B1A4E4F64CF6BDEAB9B68A91839214FA1F83A6A3C27A12DFFF7E82AB464DF76DB36BA067057565502917F04C08B50F0184CFE162CBF9C9A99CE869CB28A6319668BE4ED058F5E9D441AF8B4EE463283E653B27DEB4332D9242D0F8AF8794A1FD998A5FC209B43F2188DC76736D8C614CC3729BB76826A2CE124D43A85F3D0CF52A6553D8EFABE8ED3A5DACB81CE6765CD8743A7F5808ED7E27A3DF7DB90A7771E913E9DEB75A011462CCDFAE736C6340C8A2BD839D117848AF23C32A97D02D0B627847DE3D891F482F781CD3A9D937A50D95727C62453E3F164B316068739CC5F19C58156E2EE280429EF09A05D0B70AA3ECB601B969116B7A2B20B9790BD85083838FAB98E91BB0536C29F6DBC49647F65E637E0A5B8CBC2DF406719DCA7284A112619FA1BAFE66649BCD6367FF642B4BEE6E97D76CF908C41025EA68B4980F7C1C7D4F59C6ADD378284B204820482BF40DC9ECB121B1ADE4CF615D25D18280215ECABE2D727E8471E064BEE831520A973FDB57D49E067B803F6BE2C699283740BA2CEF6E92717EC62E02705061D8F7FC53AECF8AF3FFD1FC2F82C386C570000 , N'6.1.3-40302')
END

IF @CurrentMigration < '201506191912398_AddPostAbstract'
BEGIN
    INSERT [dbo].[__MigrationHistory]([MigrationId], [ContextKey], [Model], [ProductVersion])
    VALUES (N'201506191912398_AddPostAbstract', N'Ltd.NA.Emlak.Data.Migrations.Configuration',  0x1F8B0800000000000400E55CDB6EE3361ABE5F60DF41D055BB48AD2473B30DEC16198FD3353A3920CE148BBD3168897684EA54890A622CF6C9F6A28FB4AFB0A44EA428522225D9716630C020A1C88FFC8FFCF9F367FEF7DF3FA73FBFFA9EF102E3C40D8399793139370D18D8A1E306BB9999A2ED0F7F377FFEE9AF7F992E1CFFD5F8ADECF781F4C3238364663E23145D5956623F431F2413DFB5E33009B7686287BE059CD0BA3C3FFFD1BAB8B02086303196614C1FD300B93ECC7EC1BFCEC3C086114A81771B3AD04B8A76FC6595A11A77C08749046C38333F236772773D59F81EF87DF20920601AD79E0BF04256D0DB9A0608821001849779F525812B1487C16E15E106E03DED2388FB6D8197C062F957B4BB2A25E79784128B0E2CA1EC3441A1AF0978F1A1608DC50FEFC560B3621D66DE023319ED09D5190367E63FC29450CECF7435F762D28B672EEEE306936CD09921F874562904D61BF2EFCC98A71E4A63380B608A62E09D190FE9C673ED5FE1FE29FC1D06B320F53C768D7895F85BAD01373DC4610463B47F84DB62E54BC734ACFA388B1F580D63C6E464FD92BAF8E73B3C37D878B0D200AB7538F9BF04C06A840DC2346EC1EB6718ECD0F3CCC43F9AC68DFB0A9DB2A540FD12B8D87EF02014A79D937C82891DBB512EEFB1E7BA032FEE2E933037EBB5E3C430494CE3117AD9F7E4D98D7203CAC5BDAE7ADCC4A1FF187AA5F2941FD6AB308D6DC29F50F4F509C43B88D417340708EEC278DFB222DA855F52F945B2A6EAB36851538B1A49ABE9540CD1339E62D837683E05E5170737A162A2CB834F7497FA1B181F7C9A3956BC834F827F7D7103FBF00EEE5F6E34C79D0FCFB5108714F1D88C53760FD43BE9F98772DC37E820160790D731375865DD78C04224B3EB69463EEA1BD48BEB5DE52D9601FA70A90D70E3C6093A4AF4F6191C6422F5A0640703A41D929041A3EA95F11124B0E00009D80A856F651D20ABF88A43EC2CF65C06F36712740AC3DA4C0E6BAE1F8D6D059F1B01AEA8CFA028779E6912097234B7B162DC9BABD5937D170EF31EC046EE4BA5951F43CC681068A33C6686A989D1AE4C42252A19BF2EBA50FDA97F69A80EF759476BAE9324B4DD6C25ECFAAA33639DA845E018AD07482AE082865BAC1C6E84D501CF3D33FFD660930CB1A48141AC4E6D75CCF3C9E482A795A14A85D82AE06B5F5BF36C3A98DCC6799681A461E888048B1C956C89AD5E8B914BBE71A993DEE6E9BA583A8878CEC064EB93591B239ACAB5AA532D31D21109CE2D7C1E06083B6A18975B264060839D2F6987AFA208E30BFE986F0849B133F23410DC1544ACD1603BA41EA54E408305F5E1851D0B112A1BEFC0286CC3158250C3E940798061E441014219E573E319BE73DCA03936A68F3009C787E95D2EB55A33E5BBA58A51EA1883C1309F3F0AD4A953A69C725B46BAD8BDAA38D83EC4375C2A03C2AACD60F285315F93079D1E57D9E73284949ADBC28D362FDBC9D71EECE0A3972627DADCAF8A03D6A35FE26F87905E0651958BA5775B567EB9555E8259925BB0E92D88227C5C616EC58A1663955F89CD7F58E95F16F939866527823BA36AB5D54C288CF1918DFB4AD26E0ECCCEDBE596611A73C76F74E33714898F2D67ABED194D71959EB7EC4E7E2E0EE4FCE5E044A837948537982A1F2B7D4620E405DD1C975D49020FC4829CC73CF4523F90E54DDA46E7E760767CDEA28E503BE4B240B50F4DBCA9C53182E7B6D56037A7F9BCF094444BB79461D295EC900AF2958E3C8C84E96D088B415BB5912E8548975A5A57DC67D4F4AE685347C9AF2B588CBC451D81DE45B028B4551DA9BA6C6081AA460D9ACACB841A5965E3C95811139A0C332359B4A56047F2A18731A44553300B9958BE126759042E3A225E26E4E7FBED774D59E7E794EF7B885A947F3B9CA0B36B809A8BDB69D930730BC0A230CDEA5834CFCF42D1D6F155457F27CC322AFA42451B6F2D197B18B932897F1684693E7D43D677B065F2A79F80E4C30F23A33C8BCE8ECF5B34A45C64D16B222EDAD451F22C3A8B91B71CDF35D7CF7782730ACDE6749E466857A54307399F8AEE03F8944D93274A9A71F36B0924D211C2976A76DD851587F09E0BD35E0E3E5C3A6E96BA5D26E4AAA5BA665125973FC6F7D4049ADDEA5605DA77982EF019ACFECA50228DA60D7C86EED4D4414EF0607D10A6FB3A77717E80F2962D10414B46AFA71CEA582368494BFAF2A454A58BF0C1DAC2674355028AB2AF4ED420908138F1394443C6D00C714EF7F494A297323412C37C972AA4A912C45C22785A2465BBDF4C34B2B47917D3C8922C0EC9D0AEF609827EAE5CAB3FBCB9E7669156D9E11604EE1626282FCF302FCF2F2EB97717A7F306C24A12C71324B51B0F21EA123B423D5C1AB87FA410F313AF67EB923CDB803709C10B886DEC8CBEF3C1EBF72C52CFA2A84178F5B04A466DE31A791938F07566FE3B43B93296FF5CB34067C67D8C75EFCA3837FED36341ECC63E6C4514497D49DA2F0BDE9F36F225FE8334882FE31F04562FD51F04C596E30F02E24BEE07817165F5C328AC97CE6B60E997C7BF3F255FF4E4CDD83E57B7DCFCFD719A29FC7649EC31B4EC7B90B0F8D2EE43484A72907B1B6129EC84F2ED4F4940CD03D480B5F060436285462DFA7B3073F909EFABD69F51F466A0BEB045E67D3C55BDC47CE3EA23B0E5E5DDE3C72EE4AEA5BA752BAD8D46F95D9FA268ACC7302682071E3E402728C647E846CEFF21C6F1961B018F5B773383A0621E848F1522FFE5138C604034B14698CA445DF9F70A99B3D52E0E8C5FD15ECF6B6B579CBFA1E05BEA1BDE56F2EDC9F623883E4FBE123150A4357944B2CEC3C8F553B8968529549A65EDB3A01CBA2ECF3695A0D3B0384CAB8282F5D20E595DC3F8BAD172D9AE3CD9D19442EDC187A22177B8034DD98FE416D44DF5A87257B96139821654D9F76EEF2089430FE020E82B1A4E4F64CF6BDEAB9B68A91839214FA1F83A6A3C27A12DFFF7E82AB464DF76DB36BA067057565502917F04C08B50F0184CFE162CBF9C9A99CE869CB28A6319668BE4ED058F5E9D441AF8B4EE463283E653B27DEB4332D9242D0F8AF8794A1FD998A5FC209B43F2188DC76736D8C614CC3729BB76826A2CE124D43A85F3D0CF52A6553D8EFABE8ED3A5DACB81CE6765CD8743A7F5808ED7E27A3DF7DB90A7771E913E9DEB75A011462CCDFAE736C6340C8A2BD839D117848AF23C32A97D02D0B627847DE3D891F482F781CD3A9D937A50D95727C62453E3F164B316068739CC5F19C58156E2EE280429EF09A05D0B70AA3ECB601B969116B7A2B20B9790BD85083838FAB98E91BB0536C29F6DBC49647F65E637E0A5B8CBC2DF406719DCA7284A112619FA1BAFE66649BCD6367FF642B4BEE6E97D76CF908C41025EA68B4980F7C1C7D4F59C6ADD378284B204820482BF40DC9ECB121B1ADE4CF615D25D18280215ECABE2D727E8471E064BEE831520A973FDB57D49E067B803F6BE2C699283740BA2CEF6E92717EC62E02705061D8F7FC53AECF8AF3FFD1FC2F82C386C570000 , N'6.1.3-40302')
END
