object frmPrinc00: TfrmPrinc00
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = 'Gerador de Arquivos.EFD do SPED'
  ClientHeight = 566
  ClientWidth = 628
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    628
    566)
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TJvPageControl
    Left = 0
    Top = 81
    Width = 628
    Height = 450
    ActivePage = tabFiscal
    Anchors = [akLeft, akTop, akRight, akBottom]
    Style = tsButtons
    TabOrder = 0
    TabWidth = 150
    OnChange = PageControl1Change
    object tabFiscal: TTabSheet
      BorderWidth = 5
      Caption = 'EFD-ICMS/IPI'
      DesignSize = (
        610
        408)
      object chkBlocoD: TJvXPCheckbox
        Left = 3
        Top = 173
        Width = 607
        Height = 17
        Caption = 'Inclui Bloco D - Documentos Fiscais II - Servi'#231'os (ICMS)'
        TabOrder = 1
        BoundLines = [blLeft, blTop, blRight, blBottom]
        Anchors = [akLeft, akTop, akRight]
      end
      object chkBlocoH: TJvXPCheckbox
        Left = 3
        Top = 196
        Width = 607
        Height = 17
        Caption = 'Inclui Bloco H - Invent'#225'rio F'#237'sico'
        TabOrder = 2
        BoundLines = [blLeft, blTop, blRight, blBottom]
        Anchors = [akLeft, akTop, akRight]
      end
      object chkBloco1: TJvXPCheckbox
        Left = 3
        Top = 219
        Width = 607
        Height = 17
        Caption = 'Inclui Bloco 1 - Outras Informa'#231#245'es'
        TabOrder = 3
        BoundLines = [blLeft, blTop, blRight, blBottom]
        Anchors = [akLeft, akTop, akRight]
      end
      object rgFinalidade: TRadioGroup
        Left = 3
        Top = 48
        Width = 273
        Height = 50
        Anchors = [akLeft, akTop, akRight]
        Caption = ' C'#243'digo da finalidade do arquivo '
        ItemIndex = 0
        Items.Strings = (
          '0 - Remessa do arquivo original;'
          '1 - Remessa do arquivo substituto.')
        TabOrder = 4
      end
      object rgPerfil: TRadioGroup
        Left = 284
        Top = 48
        Width = 326
        Height = 50
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Perfil Apresenta'
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          'A - Perfil A'
          'B - Perfil B'
          'C - Perfil C')
        TabOrder = 5
      end
      object rgIndAtv: TRadioGroup
        Left = 6
        Top = 100
        Width = 604
        Height = 50
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Indicador de Atividade '
        ItemIndex = 0
        Items.Strings = (
          '0 - Industrial ou equiparado a industria'
          '1 - Outros')
        TabOrder = 6
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 610
        Height = 49
        Align = alTop
        Caption = 'Informe Empresa'
        TabOrder = 0
        object cbxEmpresa: TJvComboBox
          Left = 13
          Top = 16
          Width = 460
          Height = 22
          Style = csDropDownList
          Flat = True
          ItemHeight = 14
          ParentFlat = False
          TabOrder = 0
        end
      end
    end
    object tabContr: TTabSheet
      BorderWidth = 5
      Caption = 'EFD-Contribui'#231#245'es'
      ImageIndex = 1
      DesignSize = (
        610
        408)
      object gbxVerLay: TGroupBox
        Left = 3
        Top = 0
        Width = 290
        Height = 50
        Caption = 'C'#243'digo da vers'#227'o do leiaute'
        TabOrder = 0
        DesignSize = (
          290
          50)
        object cbxCOD_VER: TJvComboBox
          Left = 13
          Top = 18
          Width = 268
          Height = 22
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          Flat = True
          ParentFlat = False
          TabOrder = 0
        end
      end
      object gbxTIPO_ESCRIT: TRadioGroup
        Left = 320
        Top = 0
        Width = 290
        Height = 50
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Tipo de escritura'#231#227'o'
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          'Original;'
          'Retificadora.')
        TabOrder = 1
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 49
        Width = 290
        Height = 50
        Caption = 'Indicador de situa'#231#227'o especial'
        TabOrder = 2
        DesignSize = (
          290
          50)
        object cbxIND_SIT_ESP: TJvComboBox
          Left = 13
          Top = 18
          Width = 268
          Height = 22
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          Flat = True
          ParentFlat = False
          TabOrder = 0
          OnSelect = cbxIND_SIT_ESPSelect
        end
      end
      object gbxNumRecibo: TGroupBox
        Left = 320
        Top = 49
        Width = 290
        Height = 50
        Caption = 'N'#250'mero do Recibo da Escritura'#231#227'o anterior'
        TabOrder = 3
        object edtNUM_REC_ANTERIOR: TJvValidateEdit
          Left = 15
          Top = 18
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
      object GroupBox5: TGroupBox
        Left = 3
        Top = 98
        Width = 290
        Height = 50
        Caption = 'Indicador da natureza da pessoa jur'#237'dica:'
        TabOrder = 4
        DesignSize = (
          290
          50)
        object cbxIND_NAT_PJ: TJvComboBox
          Left = 13
          Top = 18
          Width = 268
          Height = 22
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          Flat = True
          ParentFlat = False
          TabOrder = 0
        end
      end
      object GroupBox6: TGroupBox
        Left = 320
        Top = 98
        Width = 290
        Height = 50
        Caption = 'Indicador de tipo de atividade preponderante:'
        TabOrder = 5
        DesignSize = (
          290
          50)
        object cbxIND_ATIV: TJvComboBox
          Left = 15
          Top = 18
          Width = 268
          Height = 22
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          Flat = True
          ParentFlat = False
          TabOrder = 0
        end
      end
      object GroupBox7: TGroupBox
        Left = 0
        Top = 151
        Width = 610
        Height = 257
        Align = alBottom
        Caption = 
          'REGISTRO 0110: Regimes de apura'#231#227'o da contribui'#231#227'o social e de a' +
          'propria'#231#227'o de cr'#233'dito'
        Padding.Left = 10
        Padding.Right = 10
        TabOrder = 6
        object Label4: TLabel
          Left = 11
          Top = 71
          Width = 586
          Height = 32
          Align = alTop
          Caption = 
            'C'#243'digo indicador de m'#233'todo de apropria'#231#227'o de cr'#233'ditos comuns, no' +
            ' caso de incid'#234'ncia no regime n'#227'o cumulativo (COD_INC_TRIB = 1 o' +
            'u 3):'
          FocusControl = cbxIND_APRO_CRED
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsItalic]
          ParentFont = False
          WordWrap = True
        end
        object Label6: TLabel
          Left = 11
          Top = 186
          Width = 588
          Height = 48
          Align = alBottom
          Caption = 
            'C'#243'digo indicador do crit'#233'rio de escritura'#231#227'o e apura'#231#227'o adotado,' +
            ' no caso de incid'#234'ncia exclusivamente no regime cumulativo (COD_' +
            'INC_TRIB = 2), pela pessoa jur'#237'dica submetida ao regime de tribu' +
            'ta'#231#227'o com baseno lucro presumido:'
          FocusControl = cbxIND_REG_CUM
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsItalic]
          ParentFont = False
          WordWrap = True
          ExplicitLeft = 13
          ExplicitTop = 178
        end
        object cbxIND_APRO_CRED: TJvComboBox
          Left = 11
          Top = 103
          Width = 588
          Height = 22
          Align = alTop
          Style = csDropDownList
          Flat = True
          ParentFlat = False
          TabOrder = 0
        end
        object cbxIND_REG_CUM: TJvComboBox
          Left = 11
          Top = 234
          Width = 588
          Height = 22
          Align = alBottom
          Style = csDropDownList
          Flat = True
          ParentFlat = False
          TabOrder = 1
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 14
          Top = 18
          Width = 582
          Height = 50
          Align = alTop
          BevelOuter = bvNone
          Color = clInfoBk
          ParentBackground = False
          TabOrder = 2
          object Label3: TLabel
            Left = 0
            Top = 0
            Width = 303
            Height = 16
            Align = alTop
            Caption = ' C'#243'digo indicador da incid'#234'ncia tribut'#225'ria no per'#237'odo:'
            Color = 14737632
            FocusControl = cbxCOD_INC_TRIB
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsItalic]
            ParentColor = False
            ParentFont = False
          end
          object cbxCOD_INC_TRIB: TJvComboBox
            Left = 0
            Top = 28
            Width = 582
            Height = 22
            Align = alBottom
            Style = csDropDownList
            Flat = True
            ParentFlat = False
            TabOrder = 0
          end
        end
        object JvPanel1: TJvPanel
          AlignWithMargins = True
          Left = 14
          Top = 128
          Width = 582
          Height = 50
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
          Align = alTop
          BevelOuter = bvNone
          Color = clInfoBk
          ParentBackground = False
          TabOrder = 3
          object Label5: TLabel
            Left = 0
            Top = 0
            Width = 357
            Height = 16
            Align = alTop
            Caption = 'C'#243'digo indicador do Tipo de Contribui'#231#227'o Apurada no Per'#237'odo:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
          end
          object cbxCOD_TIPO_CONT: TJvComboBox
            Left = 0
            Top = 28
            Width = 582
            Height = 22
            Align = alBottom
            Style = csDropDownList
            Flat = True
            ParentFlat = False
            TabOrder = 0
          end
        end
      end
    end
    object tabConfig: TTabSheet
      BorderWidth = 5
      Caption = 'Configura'#231#245'es'
      ImageIndex = 2
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 610
        Height = 50
        Align = alTop
        Caption = 
          'Selecione o local principal que conter'#225' as ramifica'#231#245'es dos arqu' +
          'ivos EFD gerados'
        TabOrder = 0
        object edtDir: TJvDirectoryEdit
          Left = 15
          Top = 19
          Width = 575
          Height = 20
          AcceptFiles = False
          OnButtonClick = edtDirButtonClick
          DialogKind = dkWin32
          DialogText = 
            'Selecione o local principal que conter'#225' as ramifica'#231#245'es dos arqu' +
            'ivos EFD gerados'
          Flat = True
          ParentFlat = False
          DialogOptionsWin32 = [odOnlyDirectory, odNoBelowDomain, odStatusAvailable, odNewDialogStyle, odValidate]
          Color = clInactiveCaption
          ButtonWidth = 25
          TabOrder = 0
        end
      end
    end
    object tabProcess: TTabSheet
      Caption = 'Andamento ...'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object mmOnLog: TJvMemo
        Left = 0
        Top = 0
        Width = 620
        Height = 418
        Align = alClient
        Flat = True
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object btnClose: TButton
    Left = 528
    Top = 537
    Width = 100
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Sair'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 628
    Height = 75
    Align = alTop
    Caption = 'Informe o periodo de apura'#231#227'o'
    TabOrder = 2
    object Label1: TLabel
      Left = 173
      Top = 16
      Width = 60
      Height = 14
      Caption = 'Data inicial:'
    end
    object Label2: TLabel
      Left = 173
      Top = 42
      Width = 54
      Height = 14
      Caption = 'Data final:'
    end
    object edtDtIni: TJvDateEdit
      Left = 255
      Top = 13
      Width = 121
      Height = 20
      DialogTitle = 'Selecione o inicio das contribu'#237#231#245'es'
      Flat = True
      ParentFlat = False
      ButtonWidth = 25
      CalendarStyle = csDialog
      TabOrder = 0
    end
    object edtDtFin: TJvDateEdit
      Left = 255
      Top = 39
      Width = 121
      Height = 20
      DialogTitle = 'Selecione o fim das contribu'#237#231#245'es'
      Flat = True
      ParentFlat = False
      ButtonWidth = 25
      CalendarStyle = csDialog
      TabOrder = 1
    end
    object edtECF_FAB: TJvValidateEdit
      Left = 401
      Top = 39
      Width = 184
      Height = 20
      Alignment = taLeftJustify
      CharCase = ecUpperCase
      CriticalPoints.MaxValueIncluded = False
      CriticalPoints.MinValueIncluded = False
      DisplayFormat = dfAlphaNumeric
      TabOrder = 2
    end
  end
  object btnExecute: TButton
    Left = 422
    Top = 537
    Width = 100
    Height = 30
    Hint = 
      'Gera a Escritura'#231#227'o Fiscal no local pre-definido na aba configur' +
      'a'#231#227'o'
    Anchors = [akRight, akBottom]
    Caption = 'Executar'
    TabOrder = 3
    OnClick = btnExecuteClick
  end
end
