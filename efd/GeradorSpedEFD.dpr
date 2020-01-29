program GeradorSpedEFD;

uses
  Forms,
  uunidac in 'C:\Projetos Berlim\Neway\units_compartilhadas\gonzaga\cdb\uunidac.pas',
  EFD00 in 'units\EFD00.pas',
  EFDCommon in 'units\EFDCommon.pas',
  EFDUtils in 'units\EFDUtils.pas',
  uefd_fiscal in '..\efd-fiscal\units\uefd_fiscal.pas',
  ufisbloco_0 in '..\efd-fiscal\units\ufisbloco_0.pas',
  ufisbloco_1 in '..\efd-fiscal\units\ufisbloco_1.pas',
  ufisbloco_C in '..\efd-fiscal\units\ufisbloco_C.pas',
  ufisbloco_D in '..\efd-fiscal\units\ufisbloco_D.pas',
  ufisbloco_E in '..\efd-fiscal\units\ufisbloco_E.pas',
  ufisbloco_G in '..\efd-fiscal\units\ufisbloco_G.pas',
  ufisbloco_H in '..\efd-fiscal\units\ufisbloco_H.pas',
  uctrbloco_0 in '..\efd-contribuicoes\units\uctrbloco_0.pas',
  uctrbloco_1 in '..\efd-contribuicoes\units\uctrbloco_1.pas',
  uctrbloco_A in '..\efd-contribuicoes\units\uctrbloco_A.pas',
  uctrbloco_C in '..\efd-contribuicoes\units\uctrbloco_C.pas',
  uctrbloco_D in '..\efd-contribuicoes\units\uctrbloco_D.pas',
  uctrbloco_F in '..\efd-contribuicoes\units\uctrbloco_F.pas',
  uctrbloco_M in '..\efd-contribuicoes\units\uctrbloco_M.pas',
  uefd_contrib in '..\efd-contribuicoes\units\uefd_contrib.pas',
  uclass in 'C:\Componentes\cunits\uclass.pas',
  ulog in 'C:\Componentes\cunits\\ulog.pas',
  ulayout01 in 'forms\layout\ulayout01.pas' {frm_layout01},
  uprinc01 in 'forms\uprinc01.pas' {frm_princ00},
  ucadcontab00 in 'forms\ucadcontab00.pas' {frm_cadcontab00},
  ufisbloco_K in '..\efd-fiscal\units\ufisbloco_K.pas',
  unfexml in '..\nfe\unfexml.pas',
  unfeutil in '..\nfe\unfeutil.pas',
  ucapicom in '..\nfe\ucapicom.pas',
  umsxml in '..\nfe\umsxml.pas',
  unfews in '..\nfe\unfews.pas',
  unfeeventxml in '..\nfe\unfeeventxml.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Neway gerador da EFD';

  ConnDatabase :=TUniConnection.GetInstance ;
  ConnDatabase.Connected :=True ;

  Application.CreateForm(Tfrm_princ00, frm_princ00);
  Application.CreateForm(Tfrm_layout01, frm_layout01);
  Application.Run;
end.
