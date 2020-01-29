inherited frm_princ00: Tfrm_princ00
  Caption = 'frm_princ00'
  ClientWidth = 628
  Constraints.MaxHeight = 690
  Constraints.MaxWidth = 640
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  ExplicitWidth = 640
  PixelsPerInch = 96
  TextHeight = 14
  inherited pnl_header: TJvNavPanelHeader
    Width = 628
    ExplicitWidth = 628
  end
  inherited pnl_footer: TAdvPanel
    Width = 628
    Color = clBtnFace
    ExplicitWidth = 628
    FullHeight = 50
    inherited btn_close: TAdvGlowButton
      Left = 528
      Caption = 'Sair'
      OnClick = btn_closeClick
      ExplicitLeft = 528
    end
    object btn_exec: TAdvGlowButton
      Left = 422
      Top = 0
      Width = 100
      Height = 30
      Hint = 'Gera escritura'#231#227'o'
      Anchors = [akRight, akBottom]
      Caption = 'Executar'
      ImageIndex = 2
      Images = ImageList1
      Notes.Strings = (
        'F2')
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clNavy
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = [fsBold]
      Rounded = False
      TabOrder = 1
      OnClick = btn_execClick
      Appearance.ColorChecked = 16111818
      Appearance.ColorCheckedTo = 16367008
      Appearance.ColorDisabled = 15921906
      Appearance.ColorDisabledTo = 15921906
      Appearance.ColorDown = 16111818
      Appearance.ColorDownTo = 16367008
      Appearance.ColorHot = 16117985
      Appearance.ColorHotTo = 16372402
      Appearance.ColorMirrorHot = 16107693
      Appearance.ColorMirrorHotTo = 16775412
      Appearance.ColorMirrorDown = 16102556
      Appearance.ColorMirrorDownTo = 16768988
      Appearance.ColorMirrorChecked = 16102556
      Appearance.ColorMirrorCheckedTo = 16768988
      Appearance.ColorMirrorDisabled = 11974326
      Appearance.ColorMirrorDisabledTo = 15921906
      Appearance.TextColorChecked = clWhite
    end
  end
  object gbx_perido: TAdvGroupBox [2]
    Left = 0
    Top = 27
    Width = 628
    Height = 100
    Align = alTop
    Caption = 'Informe o periodo de apura'#231#227'o'
    TabOrder = 2
    DesignSize = (
      628
      100)
    object Label1: TLabel
      Left = 82
      Top = 45
      Width = 60
      Height = 14
      Caption = 'Data inicial:'
    end
    object Label2: TLabel
      Left = 88
      Top = 69
      Width = 54
      Height = 14
      Caption = 'Data final:'
    end
    object edtDtIni: TJvDateEdit
      Left = 148
      Top = 45
      Width = 121
      Height = 22
      AutoSize = False
      DialogTitle = 'Selecione o inicio das contribu'#237#231#245'es'
      Flat = True
      ParentFlat = False
      ButtonWidth = 25
      CalendarStyle = csDialog
      ShowNullDate = False
      TabOrder = 1
    end
    object edtDtFin: TJvDateEdit
      Left = 148
      Top = 69
      Width = 121
      Height = 22
      AutoSize = False
      DialogTitle = 'Selecione o fim das contribu'#237#231#245'es'
      Flat = True
      ParentFlat = False
      ButtonWidth = 25
      CalendarStyle = csDialog
      ShowNullDate = False
      TabOrder = 2
    end
    object cbx_typdta: TAdvComboBox
      Left = 148
      Top = 21
      Width = 121
      Height = 22
      Color = clWindow
      Version = '1.6.1.1'
      Visible = True
      ButtonWidth = 18
      Style = csDropDownList
      EmptyTextStyle = []
      Ctl3D = False
      DropWidth = 0
      Enabled = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemIndex = -1
      LabelCaption = 'Selecione o tipo de data:'
      LabelMargin = 3
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -12
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
    end
    object chkNoRegC400: TJvXPCheckbox
      Left = 271
      Top = 46
      Width = 350
      Height = 21
      Caption = 'N'#227'o inclui registro C400: Equipamento ECF (c'#243'digo 02 e 2D)'
      TabOrder = 4
      Anchors = [akLeft, akTop, akRight]
    end
    object cbxCOD_VER: TAdvComboBox
      Left = 471
      Top = 69
      Width = 150
      Height = 22
      Color = clWindow
      Version = '1.6.1.1'
      Visible = True
      ButtonWidth = 18
      Style = csDropDownList
      EmptyTextStyle = []
      Ctl3D = False
      DropWidth = 0
      Enabled = True
      ItemIndex = -1
      LabelCaption = 'C'#243'digo da vers'#227'o do leiaute:'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      ParentCtl3D = False
      TabOrder = 5
      Anchors = [akLeft, akTop, akRight]
    end
    object edtECF_FAB: TAdvEdit
      Left = 471
      Top = 21
      Width = 150
      Height = 20
      EditType = etValidChars
      EmptyTextStyle = []
      LabelCaption = 'ECF n'#186' fabrica'#231#227'o:'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Arial'
      Lookup.Font.Style = []
      Lookup.Separator = ';'
      Color = clWindow
      TabOrder = 3
      Text = ''
      ValidChars = '0123456789'
      Visible = True
      Version = '3.3.6.0'
    end
  end
  object pag_control1: TAdvPageControl [3]
    Left = 0
    Top = 133
    Width = 628
    Height = 374
    ActivePage = tab_fiscal
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -12
    ActiveFont.Name = 'Tahoma'
    ActiveFont.Style = []
    DoubleBuffered = True
    ActiveColor = clWindow
    ActiveColorTo = clBtnFace
    TabBackGroundColor = clBtnFace
    TabMargin.RightMargin = 0
    TabOverlap = 0
    TabStyle = tsDotNet
    Version = '2.0.0.6'
    PersistPagesState.Location = plRegistry
    PersistPagesState.Enabled = False
    TabOrder = 3
    TabWidth = 121
    OnChange = pag_control1Change
    object tab_fiscal: TAdvTabSheet
      Caption = 'EFD-ICMS/IPI'
      Color = clWindow
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      ExplicitLeft = 1
      ExplicitTop = 32
      DesignSize = (
        620
        345)
      object chkBlocoD: TJvXPCheckbox
        Left = 0
        Top = 102
        Width = 620
        Height = 21
        Caption = 'Inclui Bloco D - Documentos Fiscais II - Servi'#231'os (ICMS)'
        TabOrder = 3
        BoundLines = [blLeft, blTop, blRight, blBottom]
        Anchors = [akLeft, akTop, akRight]
      end
      object chkBlocoH: TJvXPCheckbox
        Left = 0
        Top = 129
        Width = 620
        Height = 21
        Caption = 'Inclui Bloco H - Invent'#225'rio F'#237'sico'
        TabOrder = 4
        BoundLines = [blLeft, blTop, blRight, blBottom]
        Anchors = [akLeft, akTop, akRight]
      end
      object chkBloco1: TJvXPCheckbox
        Left = 0
        Top = 156
        Width = 620
        Height = 21
        Caption = 'Inclui Bloco 1 - Outras Informa'#231#245'es'
        TabOrder = 5
        BoundLines = [blLeft, blTop, blRight, blBottom]
        Anchors = [akLeft, akTop, akRight]
      end
      object rg_Perfil: TAdvOfficeRadioGroup
        Left = 303
        Top = 0
        Width = 317
        Height = 55
        Version = '1.3.9.1'
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Perfil'
        ParentBackground = False
        TabOrder = 1
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          'Perfil A'
          'Perfil B'
          'Perfil C')
        Ellipsis = False
      end
      object rg_IndAtv: TAdvOfficeRadioGroup
        Left = 0
        Top = 56
        Width = 620
        Height = 40
        Version = '1.3.9.1'
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Indicador de Atividade '
        ParentBackground = False
        TabOrder = 2
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          '0 - Industrial ou equiparado a industria'
          '1 - Outros')
        Ellipsis = False
      end
      object rg_Final: TAdvOfficeRadioGroup
        Left = 0
        Top = 0
        Width = 297
        Height = 55
        Version = '1.3.9.1'
        Caption = 'C'#243'digo da finalidade do arquivo'
        ParentBackground = False
        TabOrder = 0
        ItemIndex = 0
        Items.Strings = (
          '0 - Remessa do arquivo original;'
          '1 - Remessa do arquivo substituto.')
        Ellipsis = False
      end
      object btn_LocalSai: TAdvGlowButton
        Left = 520
        Top = 183
        Width = 100
        Height = 30
        Cursor = crHandPoint
        Hint = 'Adiciona arquivos EFD-ICMS/IPI'
        Anchors = [akRight, akBottom]
        Caption = 'Adicionar'
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F8000006034944415478DA9D555B6C145518FEFFB9EDCEDEBA4BBBF76DB7EDB6
          40BB4B001B4A8110BC273EF8C683244A09C688C56062A23E986882FA48622209
          10F112AE8951A08088214188221888421758080886D62D2D2DEDB6DD999DEBF1
          9FAD36C650483CC9D94C66CF9CEFFCDFE53F786EFFDA4D16081BC275C17B82C0
          F7731C37C0F3D5D98F1C0C542AFA40F1DEE4C88AD5DB2DF81F03BFF9F8F9BC69
          632ED31063048080F4D6B6190D1478010449641C87154EE00609BC0ACAD14144
          49389E5CF2D1E94702FCD6DB931F19537292C0318F5B4439B2106A9B9F66863A
          8696360E5A799419CA28EACA7D105101D0C71872887228BCAD65E5873D8F04B8
          7A6C53BE2E12CF8E954A502C0E831C590C998E35E0F578C0E5720122CE2C364C
          0B544D070207CB36FA4D0C9ED64D7667A4A4ECED6C4F151E08507000A2F19CA9
          6BCC225A06CB7550911F63C3C343284912CC09CD617EBF1F2597043E9F0F788E
          638228A2DFE7679224123AC2953F86BA1734C7763DA48258CEB60C06B6851643
          18361A58A1E8A1C373A011702814C248245AFD40AB5498EC91D1300CE676B930
          95AA877B654600D107035C3EB2311F8EC6B3B6A903710BAAA2825A9E02DBDF08
          3726B3A06B1A78882EAFD70BE42C9A3CE8BA0EA22856294CD513C0A4B56E6166
          960A2EF56EC84762C9E90A88224D554137882E5EC6B3C51C101D8C68C2FA8606
          A09383AAAA4C9665ACADAD639669A22889706768B27B71CB2C00F9A31BF375E1
          58CE327402B0D1304DD0548531970F4FDE6A214A3416248AD2E974F5039DD6C9
          6E192DCB64A22861AABE01C614BBBBA3353E0BC0E19E7C6D384A141924970DA6
          454E51CAC05C7E3833B8100CA223964C42381C06AAB04A8F42144E53E486442A
          05E3657B5DE7BCC42C00BDAFE523718722932AB0B0421A98B6C50C74E1E12B29
          E0059ED58523986E6C029F3F006235781C12FF8C5C8054050C8F96BBBBE62766
          13F9F57C3816CF826D826598605225064DC5E4E1E0E504615A10A80942EBFC36
          2A80414555C02DCB4020D50DE2C914A806BF6E455BF22136250D68274634A141
          1B3A1654C85407A802DA904563714C901D1D0791D318B359F5C7455A241BD230
          451AAC6C9F05A0F0DD1BD51C384143604491029AA6311D253C74AD1104416081
          60109B32ADE4222F45C562BC2810456E661A067A287C5365B37B5536F588A099
          465503C745CAD414D36C01BFA60A9C6005C9A6AD6DED04263A19611205CCEB0F
          30E7FB703C01C343E32F3DB764EE9E078B7CA4878296A8068D73825656AA2E01
          77008E5E6B70E882CCBC36C82E5C547DB66C9B9C654CAF211DA8CDC096CD9B5F
          DCBB73EB41669390004E5BB767002EF66EE88BC6920BA65D64CF04CD60121EB8
          5857A5684E6D2DB665B3E420895C2550056EA46A98E476634D680E3CD5D5F5EA
          D5BE5FF3B45F85E608CDE2DF4094E4C33D7D91687CC13F4173725051CA94640F
          7E7BB3994EAB314A2DE616774030E0A3939719E98C940F46A293C88DECC9AECE
          0F6E5C2F5C217DFA65D9535055657CA682D37BD69F6FCDA43BA683C628682605
          4D014BF042EFAD79E0DC4091781C12CD0B6070709440A85DE808F58920242201
          B87EE922F4FDFC03C41329C3EDF15E9E989C3A355956CF140A85733BB76E29E2
          8D136FAD2797EC2000DEE9A615A28878661512F9CB7341EA45120B51D0721D9D
          C013C5778787993F548BE1688CF114B4F3278E004F0949A65258130C823F1060
          3E7FC8D8BF77CFC9DD5F7CBEB17A9BDC3DB77925DD2BBB2DD3489B1436C3D4D9
          5485E1AEB37EA85454BA0F02389F34181FB90F3BB76F6313E325A7301608D4E0
          E34FACA2705AAC6BF932E40489FD591CBC79E2D891B725913F7AFCD85173E6BA
          BAF3D3FB3522DADB4CDB7EC1E93FF74BE5A935EFFE78209D6949AD78F299FA45
          4B9636998626DCB97D0B868A0370EFEE1094C64BE071BB4104282F5BB6548C45
          639220F240F7845D9A98D8F7D9CE4FD7E17F7D7BF3FB37D752A7FC6442D1CC25
          AB77BC42AF2EC85EDFDD404D28DC3437DBD9D2D6BE3CD3D6DED53CAF3D97BFF0
          CB95635FEDDB7EA370E91459D41D0C86D2D479931ED9534396B66EDFFE7D173E
          281C7D873664464B95F79E7D79D73B86690FD12BF6EFFF6B42759C69E81EDBB6
          74EABC3A3C64FC050FF11CE451E3398C0000000049454E44AE426082}
        Rounded = False
        WordWrap = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = btn_LocalSaiClick
        Appearance.ColorChecked = 16111818
        Appearance.ColorCheckedTo = 16367008
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 16111818
        Appearance.ColorDownTo = 16367008
        Appearance.ColorHot = 16117985
        Appearance.ColorHotTo = 16372402
        Appearance.ColorMirrorHot = 16107693
        Appearance.ColorMirrorHotTo = 16775412
        Appearance.ColorMirrorDown = 16102556
        Appearance.ColorMirrorDownTo = 16768988
        Appearance.ColorMirrorChecked = 16102556
        Appearance.ColorMirrorCheckedTo = 16768988
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.TextColorChecked = clWhite
      end
      object btn_clear: TAdvGlowButton
        Left = 520
        Top = 219
        Width = 100
        Height = 30
        Cursor = crHandPoint
        Hint = 'Remove arquivos EFD-ICMS/IPI'
        Anchors = [akRight, akBottom]
        Caption = 'Limpar'
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F8000004CE4944415478DA95556B6C1455143E67667767BB6B774BB7CB23A16A
          282424352C3666A320DA1736A436B12E360408B13F3629069B2A82A4FDA190B4
          B0B5468526FDD160ABE03FD6C6D61609492992544B81D81FBEAAB53126C0963E
          6C1B7677761ED733C3CC3AC5B6D29B4CE6DE73EE39DF39DF39F75E84150C3FC7
          712A63C021B27BAACA1EC5069753E66664F0EB787ED30B7979651B727303ABB3
          B2566BF23BD3D3777F1D1B1BB93A3E7E29C6D81F139224AF0860BDD3C9E5FB7C
          CFD65656BE5F565656CC793CBC45CD743BCA428EC5E4AFBABB2F3777759D184F
          266F4CCAB2F2BF00798220540702C78FD4D51DB66566F2F00823353595AA8F44
          4E9E1B1D6D9E5494C492004FDAED42434141C7EB35357B90E74D1D7B689FB9B6
          CA19C832B4B4B69E8D8C8CD4CE5840D2865A010F6EDC78B23E1C3E8A36DB0263
          5C0600AD32C6586D5BDBF1F363638DF3AA2A2F00D8EE74EEE80D87FBED165A64
          E501A5769E5F944F89F468E84D5D22991483A74F978CCAF260DAC68B686FDBB2
          E5E2AE60B04417502492AAA2BDBA1A501058BCBD1DDDD49EA8C54B3ACD2E4E45
          CE0887918922A81D1DCC41949AD99CBB79F3EB376FDDAA4A012475591E62FEB7
          A5A5233697CB245E077037348027186473C3C3387FEA14B85555D7C5390E338F
          1D63A4C3F9A121101B1B998364A66D5214539B2F5D2A9866EC275DB6D7ED3E7C
          72EBD60F408BD24245C26E077F2402DE601066070761BABE5ED76537358167DB
          36981F1E8699A347C12D490BEC388703F60D0DD57D93489C413BC9DFF5F93EDB
          9793B31F8DA26944402A852C958204CFB3DCCE4ECC2E2A82A981013D425F6121
          FE3D38C8260E1E44375184462398B6DABC6566E66CCBC4440D52F9F8A6ECECBE
          529B6D2712052C91D03F6D6E4625BA5CB0A1A7077208441B1AD0ED0307C04D01
          987B38E36F7E9F2B4A4FC3D45495866A3B9195D55B188FEFA48891B34461CE45
          41C04DD128AC2D2FD76ACC26FAFAF0CF5088B9B4FD369B7E37510320A7514C7A
          5414FCC2E9EC7E2F1EAFD29C706F78BD9D15B3B3FBAD4E39236589BA283F1AC5
          75E4FC6E7FBFAE5B535C8CB1DE5E36160A610651C43D1490667B46103E6D13C5
          1ABD2E2FB9DD470EA55211902434D2D50D644180A7A351B6BEBC1C35E73F5454
          E8BA404F0FAE2E2A6231CA64341402A728EA4E39C396CE2C1E0278FB9AAA7EAC
          03AC0208B4E7E4DC50272779934FAD219F215A9EA8AC843B57AEC07572EE8CC7
          759D443529A09AACA59ADCEEEA82DF08C461D8695F0251DCC5D876BA2F6EE900
          24CC786BCD9AEE402C566A664000F8DC850B6073BBD97744856038E70C0A6497
          8B5100A8DCBF0F3FEFDECD044B065F025CFC08600F2DE7D3A77F1DC79534F9FD
          7D4A2CE63079540D4E293AADDB160098416832D233DE9853D4896A8057A6012E
          1BF7987138685F89D7DBF81A6387E5B9B974DB71968F7F68BD98AC05A0F92AC0
          099AC6FF737FD122EB559FAFB55892F61248BAE0DC1219F0D6C2D2FF3CB57F37
          C0119ADE5BF43D30419EF778EA432E572DBD5802F5B6B543C0E2380D20122D1D
          00A7BF07F8D0EA7C510063385721BEF8B2DFFF4E405577F0F1B843F9B7C83A2D
          3CC781C858F23A63D7FA003E99052066E0FE22012F39345D2675C7E68D8250F4
          B8203CF598AAFA19BD01738A72EF2F49FAF177C60624805F68DF2C3C78746025
          00D6A1054EF722D88CB5F65A49C6715976FC037C4E0953C66E1F620000000049
          454E44AE426082}
        Rounded = False
        WordWrap = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = btn_clearClick
        Appearance.ColorChecked = 16111818
        Appearance.ColorCheckedTo = 16367008
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 16111818
        Appearance.ColorDownTo = 16367008
        Appearance.ColorHot = 16117985
        Appearance.ColorHotTo = 16372402
        Appearance.ColorMirrorHot = 16107693
        Appearance.ColorMirrorHotTo = 16775412
        Appearance.ColorMirrorDown = 16102556
        Appearance.ColorMirrorDownTo = 16768988
        Appearance.ColorMirrorChecked = 16102556
        Appearance.ColorMirrorCheckedTo = 16768988
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.TextColorChecked = clWhite
      end
      object pag_Saidas: TAdvPageControl
        Left = 0
        Top = 183
        Width = 518
        Height = 162
        ActivePage = AdvTabSheet1
        ActiveFont.Charset = DEFAULT_CHARSET
        ActiveFont.Color = clWindowText
        ActiveFont.Height = -11
        ActiveFont.Name = 'Tahoma'
        ActiveFont.Style = []
        DoubleBuffered = True
        TabBackGroundColor = clBtnFace
        TabMargin.RightMargin = 0
        TabOverlap = 0
        Version = '2.0.0.6'
        PersistPagesState.Location = plRegistry
        PersistPagesState.Enabled = False
        TabOrder = 8
        object AdvTabSheet1: TAdvTabSheet
          Caption = 'Arquivos EFD-ICMS/IPI gerados por ECF'
          Color = clWindow
          ColorTo = clNone
          TabColor = clBtnFace
          TabColorTo = clNone
          object lbx_saidas: TJvListBox
            Left = 0
            Top = 0
            Width = 510
            Height = 128
            Align = alClient
            ExtendedSelect = False
            IntegralHeight = True
            ItemHeight = 14
            Background.FillMode = bfmTile
            Background.Visible = False
            Flat = True
            TabOrder = 0
            ExplicitTop = 2
          end
        end
        object AdvTabSheet2: TAdvTabSheet
          Caption = 'NF-e saidas'
          Color = clWindow
          ColorTo = clNone
          TabVisible = False
          TabColor = clBtnFace
          TabColorTo = clNone
        end
        object AdvTabSheet3: TAdvTabSheet
          Caption = 'NF-e Entradas'
          Color = clWindow
          ColorTo = clNone
          TabVisible = False
          TabColor = clBtnFace
          TabColorTo = clNone
        end
      end
    end
    object tab_contr: TAdvTabSheet
      BorderWidth = 3
      Caption = 'EFD-Contribu'#237#231#245'es'
      Color = clWindow
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      object gbxTIPO_ESCRIT: TRadioGroup
        Left = 0
        Top = 0
        Width = 614
        Height = 40
        Align = alTop
        Caption = 'Tipo de escritura'#231#227'o'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Original;'
          'Retificadora.')
        TabOrder = 0
      end
      object GroupBox4: TAdvGroupBox
        Left = 0
        Top = 39
        Width = 290
        Height = 50
        Caption = 'Indicador de situa'#231#227'o especial'
        TabOrder = 1
        DesignSize = (
          290
          50)
        object cbxIND_SIT_ESP: TAdvComboBox
          Left = 10
          Top = 20
          Width = 268
          Height = 22
          Color = clWindow
          Version = '1.6.1.1'
          Visible = True
          ButtonWidth = 18
          Style = csDropDownList
          EmptyTextStyle = []
          Ctl3D = False
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          ParentCtl3D = False
          TabOrder = 0
          Anchors = [akLeft, akTop, akRight]
        end
      end
      object gbxNumRecibo: TAdvGroupBox
        Left = 324
        Top = 39
        Width = 290
        Height = 50
        Caption = 'N'#250'mero do Recibo da Escritura'#231#227'o anterior'
        TabOrder = 2
        object edtNUM_REC_ANTERIOR: TJvValidateEdit
          Left = 10
          Top = 20
          Width = 258
          Height = 20
          Alignment = taLeftJustify
          CheckChars = '0123456789'
          CriticalPoints.MaxValueIncluded = False
          CriticalPoints.MinValueIncluded = False
          DisplayFormat = dfCheckChars
          TabOrder = 0
        end
      end
      object GroupBox5: TAdvGroupBox
        Left = 0
        Top = 89
        Width = 290
        Height = 50
        Caption = 'Indicador da natureza da pessoa jur'#237'dica:'
        TabOrder = 3
        DesignSize = (
          290
          50)
        object cbxIND_NAT_PJ: TAdvComboBox
          Left = 10
          Top = 20
          Width = 268
          Height = 22
          Color = clWindow
          Version = '1.6.1.1'
          Visible = True
          ButtonWidth = 18
          Style = csDropDownList
          EmptyTextStyle = []
          Ctl3D = False
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          ParentCtl3D = False
          TabOrder = 0
          Anchors = [akLeft, akTop, akRight]
        end
      end
      object GroupBox6: TAdvGroupBox
        Left = 324
        Top = 89
        Width = 290
        Height = 50
        Caption = 'Indicador de tipo de atividade preponderante:'
        TabOrder = 4
        DesignSize = (
          290
          50)
        object cbxIND_ATIV: TAdvComboBox
          Left = 10
          Top = 20
          Width = 268
          Height = 22
          Color = clWindow
          Version = '1.6.1.1'
          Visible = True
          ButtonWidth = 18
          Style = csDropDownList
          EmptyTextStyle = []
          Ctl3D = False
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          ParentCtl3D = False
          TabOrder = 0
          Anchors = [akLeft, akTop, akRight]
        end
      end
      object GroupBox7: TAdvGroupBox
        Left = 0
        Top = 139
        Width = 614
        Height = 200
        Align = alBottom
        Caption = 
          'REGISTRO 0110: Regimes de apura'#231#227'o da contribui'#231#227'o social e de a' +
          'propria'#231#227'o de cr'#233'dito'
        TabOrder = 5
        object cbxIND_APRO_CRED: TAdvComboBox
          Left = 10
          Top = 79
          Width = 588
          Height = 22
          Hint = 
            'C'#243'digo indicador de m'#233'todo de apropria'#231#227'o de cr'#233'ditos comuns, no' +
            ' caso de incid'#234'ncia no regime n'#227'o cumulativo (COD_INC_TRIB = 1 o' +
            'u 3):'
          Color = clWindow
          Version = '1.6.1.1'
          Visible = True
          ButtonWidth = 18
          Style = csDropDownList
          EmptyTextStyle = []
          Ctl3D = False
          DropWidth = 0
          Enabled = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = -1
          LabelCaption = 'C'#243'digo indicador de m'#233'todo de apropria'#231#227'o de cr'#233'ditos comuns:'
          LabelPosition = lpTopLeft
          LabelMargin = 3
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clNavy
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object cbxIND_REG_CUM: TAdvComboBox
          Left = 10
          Top = 168
          Width = 588
          Height = 22
          Hint = 
            'C'#243'digo indicador do crit'#233'rio de escritura'#231#227'o e apura'#231#227'o adotado,' +
            ' no caso de incid'#234'ncia exclusivamente no regime cumulativo (COD_' +
            'INC_TRIB = 2), pela pessoa jur'#237'dica submetida ao regime de tribu' +
            'ta'#231#227'o com base no lucro presumido:'
          Color = clWindow
          Version = '1.6.1.1'
          Visible = True
          ButtonWidth = 18
          Style = csDropDownList
          EmptyTextStyle = []
          Ctl3D = False
          DropWidth = 0
          Enabled = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = -1
          LabelCaption = 'C'#243'digo indicador do crit'#233'rio de escritura'#231#227'o e apura'#231#227'o adotado:'
          LabelPosition = lpTopLeft
          LabelMargin = 3
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clNavy
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object cbxCOD_INC_TRIB: TAdvComboBox
          Left = 10
          Top = 34
          Width = 588
          Height = 22
          Color = clWindow
          Version = '1.6.1.1'
          Visible = True
          ButtonWidth = 18
          Style = csDropDownList
          EmptyTextStyle = []
          Ctl3D = False
          DropWidth = 0
          Enabled = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = -1
          LabelCaption = 'C'#243'digo indicador da incid'#234'ncia tribut'#225'ria no per'#237'odo:'
          LabelPosition = lpTopLeft
          LabelMargin = 3
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clNavy
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object cbxCOD_TIPO_CONT: TAdvComboBox
          Left = 10
          Top = 124
          Width = 588
          Height = 22
          Color = clWindow
          Version = '1.6.1.1'
          Visible = True
          ButtonWidth = 18
          Style = csDropDownList
          EmptyTextStyle = []
          Ctl3D = False
          DropWidth = 0
          Enabled = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = -1
          LabelCaption = 'C'#243'digo indicador do Tipo de Contribui'#231#227'o Apurada no Per'#237'odo:'
          LabelPosition = lpTopLeft
          LabelMargin = 3
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clNavy
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
      end
    end
    object tab_config: TAdvTabSheet
      BorderWidth = 3
      Caption = 'Configura'#231#245'es'
      Color = clWindow
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      object gbx_LocalEFD: TAdvGroupBox
        Left = 0
        Top = 0
        Width = 614
        Height = 50
        Align = alTop
        Caption = 
          'Selecione o local onde os arquivos EFD seram gerados por CNPJ, a' +
          'no e m'#234's de refer'#234'ncia'
        TabOrder = 0
        object edtDir: TJvDirectoryEdit
          Left = 15
          Top = 19
          Width = 575
          Height = 20
          AcceptFiles = False
          DialogKind = dkWin32
          DialogText = 'Selecione o local onde os arquivos EFD seram gerados'
          Flat = True
          ParentFlat = False
          DialogOptionsWin32 = [odOnlyDirectory, odNoBelowDomain, odStatusAvailable, odNewDialogStyle, odValidate]
          Color = clInactiveCaption
          ButtonWidth = 25
          TabOrder = 0
          Text = ''
        end
      end
      object pag_control2: TAdvPageControl
        Left = 0
        Top = 53
        Width = 614
        Height = 286
        ActivePage = tab_empresa
        ActiveFont.Charset = DEFAULT_CHARSET
        ActiveFont.Color = clWindowText
        ActiveFont.Height = -12
        ActiveFont.Name = 'Tahoma'
        ActiveFont.Style = []
        DoubleBuffered = True
        ActiveColor = clWindow
        ActiveColorTo = clBtnFace
        TabBackGroundColor = clBtnFace
        TabMargin.RightMargin = 0
        TabOverlap = 0
        TabStyle = tsDotNet
        Version = '2.0.0.6'
        PersistPagesState.Location = plRegistry
        PersistPagesState.Enabled = False
        TabOrder = 1
        object tab_empresa: TAdvTabSheet
          BorderWidth = 3
          Caption = ' Identifica'#231#227'o da Entidade / Pessoa Jur'#237'dica '
          Color = clWindow
          ColorTo = clNone
          TabColor = clBtnFace
          TabColorTo = clNone
          object cbxEmp: TAdvComboBox
            Left = 0
            Top = 0
            Width = 600
            Height = 22
            Color = clWindow
            Version = '1.6.1.1'
            Visible = True
            Align = alTop
            ButtonWidth = 18
            Style = csDropDownList
            EmptyTextStyle = []
            Ctl3D = False
            DropWidth = 0
            Enabled = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemIndex = -1
            LabelPosition = lpTopLeft
            LabelMargin = 3
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -12
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
          end
        end
        object tab_contab: TAdvTabSheet
          BorderWidth = 3
          Caption = ' Contabilista '
          Color = clWindow
          ColorTo = clNone
          TabColor = clBtnFace
          TabColorTo = clNone
          DesignSize = (
            600
            251)
          object vst_Contab: TVirtualStringTree
            Left = 0
            Top = 0
            Width = 600
            Height = 90
            Align = alTop
            Anchors = [akLeft, akTop, akRight, akBottom]
            Header.AutoSizeIndex = 0
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clNavy
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Header.Height = 21
            Header.Options = [hoDrag, hoVisible]
            Header.Style = hsFlatButtons
            TabOrder = 0
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
            TreeOptions.PaintOptions = [toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines]
            TreeOptions.SelectionOptions = [toFullRowSelect]
            OnChecked = vst_ContabChecked
            OnGetText = vst_ContabGetText
            Columns = <
              item
                Alignment = taCenter
                CaptionAlignment = taCenter
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
                Position = 0
                Width = 55
                WideText = 'C'#243'digo'
              end
              item
                Position = 1
                Width = 195
                WideText = 'Nome'
              end
              item
                Alignment = taCenter
                CaptionAlignment = taCenter
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
                Position = 2
                Width = 105
                WideText = 'CPF'
              end
              item
                Alignment = taCenter
                CaptionAlignment = taCenter
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
                Position = 3
                WideText = 'CRC'
              end
              item
                Position = 4
                Width = 175
                WideText = 'Local'
              end>
            WideDefaultText = '10515'
          end
          object btn_cntnew: TAdvGlowButton
            Left = 265
            Top = 96
            Width = 100
            Height = 30
            Anchors = [akRight, akBottom]
            Caption = 'Novo'
            ImageIndex = 4
            Images = ImageList1
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            Rounded = False
            TabOrder = 1
            OnClick = btn_cntnewClick
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Appearance.TextColorChecked = clWhite
          end
          object btn_cntedt: TAdvGlowButton
            Left = 371
            Top = 96
            Width = 100
            Height = 30
            Anchors = [akRight, akBottom]
            Caption = 'Alterar'
            ImageIndex = 5
            Images = ImageList1
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            Rounded = False
            TabOrder = 2
            OnClick = btn_cntedtClick
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
            Appearance.TextColorChecked = clWhite
          end
        end
      end
    end
    object tab_process: TAdvTabSheet
      Caption = 'Andamento...'
      Color = clWindow
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      object mmOnLog: TJvMemo
        Left = 0
        Top = 0
        Width = 620
        Height = 345
        Align = alClient
        Flat = True
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
      end
    end
    object tab_Nfe: TAdvTabSheet
      Caption = 'Importar NF-e'
      Color = clWindow
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      object pnl_NfeEntrada: TAdvPanel
        Left = 0
        Top = 0
        Width = 620
        Height = 171
        Align = alTop
        BevelOuter = bvNone
        Color = 16643823
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        UseDockManager = True
        Version = '2.4.1.0'
        AutoHideChildren = False
        BorderColor = 13087391
        BorderWidth = 1
        Caption.Color = 16643823
        Caption.ColorTo = 15784647
        Caption.Font.Charset = DEFAULT_CHARSET
        Caption.Font.Color = 5978398
        Caption.Font.Height = -11
        Caption.Font.Name = 'Tahoma'
        Caption.Font.Style = []
        Caption.GradientDirection = gdVertical
        Caption.Indent = 2
        Caption.ShadeLight = 255
        Caption.Text = 'Notas fiscais de entradas'
        Caption.Visible = True
        CollapsColor = clNone
        CollapsDelay = 0
        ColorTo = 15784647
        DoubleBuffered = True
        ShadowColor = clBlack
        ShadowOffset = 0
        StatusBar.BorderColor = 16643823
        StatusBar.BorderStyle = bsSingle
        StatusBar.Font.Charset = DEFAULT_CHARSET
        StatusBar.Font.Color = 5978398
        StatusBar.Font.Height = -11
        StatusBar.Font.Name = 'Tahoma'
        StatusBar.Font.Style = []
        StatusBar.Text = 
          '[Ctrl]+[Ins] Adicionar, [Ctrl]+[Del] Limpar ou but'#227'o direito do ' +
          'Mouse'
        StatusBar.Color = 16643823
        StatusBar.ColorTo = 15784647
        StatusBar.GradientDirection = gdVertical
        StatusBar.Visible = True
        Styler = AdvPanelStyler1
        Text = ''
        FullHeight = 171
        object lbx_NFeEnt: TJvListBox
          Left = 1
          Top = 19
          Width = 618
          Height = 133
          DotNetHighlighting = True
          Align = alClient
          ExtendedSelect = False
          ItemHeight = 15
          SeparateItems = True
          Background.FillMode = bfmTile
          Background.Visible = False
          Flat = True
          ParentFlat = False
          ScrollBars = ssVertical
          Style = lbOwnerDrawVariable
          TabOrder = 0
          OnEnter = lbx_NFeEntEnter
        end
      end
      object pnl_NfeSaida: TAdvPanel
        Left = 0
        Top = 174
        Width = 620
        Height = 171
        Align = alBottom
        BevelOuter = bvNone
        Color = 16643823
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        UseDockManager = True
        Version = '2.4.1.0'
        AutoHideChildren = False
        BorderColor = 13087391
        BorderWidth = 1
        Caption.Color = 16643823
        Caption.ColorTo = 15784647
        Caption.Font.Charset = DEFAULT_CHARSET
        Caption.Font.Color = 5978398
        Caption.Font.Height = -11
        Caption.Font.Name = 'Tahoma'
        Caption.Font.Style = []
        Caption.GradientDirection = gdVertical
        Caption.Indent = 2
        Caption.ShadeLight = 255
        Caption.Text = 'Notas fiscais de saidas'
        Caption.Visible = True
        CollapsColor = clNone
        CollapsDelay = 0
        ColorTo = 15784647
        DoubleBuffered = True
        ShadowColor = clBlack
        ShadowOffset = 0
        StatusBar.BorderColor = 16643823
        StatusBar.BorderStyle = bsSingle
        StatusBar.Font.Charset = DEFAULT_CHARSET
        StatusBar.Font.Color = 5978398
        StatusBar.Font.Height = -11
        StatusBar.Font.Name = 'Tahoma'
        StatusBar.Font.Style = []
        StatusBar.Text = 
          '[Ctrl]+[Ins] Adicionar, [Ctrl]+[Del] Limpar ou but'#227'o direito do ' +
          'Mouse'
        StatusBar.Color = 16643823
        StatusBar.ColorTo = 15784647
        StatusBar.GradientDirection = gdVertical
        StatusBar.Visible = True
        Styler = AdvPanelStyler1
        Text = ''
        FullHeight = 171
        object lbx_NFe: TJvListBox
          Left = 1
          Top = 19
          Width = 618
          Height = 133
          DotNetHighlighting = True
          Align = alClient
          ExtendedSelect = False
          ItemHeight = 15
          SeparateItems = True
          Background.FillMode = bfmTile
          Background.Visible = False
          Flat = True
          ScrollBars = ssVertical
          Style = lbOwnerDrawVariable
          TabOrder = 0
          OnEnter = lbx_NFeEntEnter
        end
      end
    end
  end
  object AdvPanelStyler1: TAdvPanelStyler
    Tag = 0
    Settings.AnchorHint = False
    Settings.AutoHideChildren = False
    Settings.BevelInner = bvNone
    Settings.BevelOuter = bvNone
    Settings.BevelWidth = 1
    Settings.BorderColor = 13087391
    Settings.BorderShadow = False
    Settings.BorderStyle = bsNone
    Settings.BorderWidth = 1
    Settings.CanMove = False
    Settings.CanSize = False
    Settings.Caption.Color = 16643823
    Settings.Caption.ColorTo = 15784647
    Settings.Caption.Font.Charset = DEFAULT_CHARSET
    Settings.Caption.Font.Color = 5978398
    Settings.Caption.Font.Height = -11
    Settings.Caption.Font.Name = 'Tahoma'
    Settings.Caption.Font.Style = []
    Settings.Caption.GradientDirection = gdVertical
    Settings.Caption.Indent = 2
    Settings.Caption.ShadeLight = 255
    Settings.Collaps = False
    Settings.CollapsColor = clNone
    Settings.CollapsDelay = 0
    Settings.CollapsSteps = 0
    Settings.Color = 16643823
    Settings.ColorTo = 15784647
    Settings.ColorMirror = clNone
    Settings.ColorMirrorTo = clNone
    Settings.Cursor = crDefault
    Settings.Font.Charset = DEFAULT_CHARSET
    Settings.Font.Color = clBlack
    Settings.Font.Height = -11
    Settings.Font.Name = 'Tahoma'
    Settings.Font.Style = []
    Settings.FixedTop = False
    Settings.FixedLeft = False
    Settings.FixedHeight = False
    Settings.FixedWidth = False
    Settings.Height = 120
    Settings.Hover = False
    Settings.HoverColor = clNone
    Settings.HoverFontColor = clNone
    Settings.Indent = 0
    Settings.ShadowColor = clBlack
    Settings.ShadowOffset = 0
    Settings.ShowHint = False
    Settings.ShowMoveCursor = False
    Settings.StatusBar.BorderColor = 16643823
    Settings.StatusBar.BorderStyle = bsSingle
    Settings.StatusBar.Font.Charset = DEFAULT_CHARSET
    Settings.StatusBar.Font.Color = 5978398
    Settings.StatusBar.Font.Height = -11
    Settings.StatusBar.Font.Name = 'Tahoma'
    Settings.StatusBar.Font.Style = []
    Settings.StatusBar.Color = 16643823
    Settings.StatusBar.ColorTo = 15784647
    Settings.StatusBar.GradientDirection = gdVertical
    Settings.TextVAlign = tvaTop
    Settings.TopIndent = 0
    Settings.URLColor = clBlue
    Settings.Width = 0
    Style = psCustom
    Left = 568
    Top = 24
  end
  object PopupMenu1: TPopupMenu
    Left = 400
    Top = 232
    object mnu_Inserir1: TMenuItem
      Action = act_NfeIns
    end
    object mnu_Limpar1: TMenuItem
      Action = act_NfeClear
    end
  end
  object ActionList1: TActionList
    Left = 456
    Top = 232
    object act_NfeIns: TAction
      Category = 'NFE'
      Caption = 'Inserir ...'
      ShortCut = 16429
      OnExecute = act_NfeInsExecute
    end
    object act_NfeClear: TAction
      Category = 'NFE'
      Caption = 'Limpar'
      ShortCut = 16430
      OnExecute = act_NfeClearExecute
    end
  end
end
