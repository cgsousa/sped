{*******************************************************}
{                                                       }
{       SPED Sistema Publico de Escrituracao Digital    }
{       EFD Utilidades                                  }
{       Copyright (c) 1992,2012 Suporteware             }
{       Created by Carlos Gonzaga                       }
{                                                       }
{*******************************************************}
{*
Descrição:  Utilidades para para criacao e gereção dos
            arquivos EFD

Historico   Descrição
=========== =============================================
05.05.2011  Versão inicial
*}
unit EFDUtils;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  Contnrs;

type
//  EFD_Util = class
//  end;
  Tefd_util = class
  private
    class function AlignStr(const ALen: Integer;
                            const AStr: string;
                            const AChar: Char;
                            const Align: TAlignment=taLeftJustify): string;
    class function AlignLeft(const ALen: Integer;
                             const AStr: string;
                             const AChar: Char=' '): string;
    class function AlignRight(const ALen: Integer;
                              const AStr: string;
                              const AChar: Char='0'): string;
  public
    class function FBoo(const AValue: Boolean): string ;
    class function FDat(const AValue: TDateTime): string ;
    class function FCur(const AValue: Currency;
                        const ADefault:string=''): string ;
    class function FFlt(const AValue: Extended;
                        const AFormat:string='0.00';
                        const ADefault:string=''): string ;
    class function FInt(const AValue: Integer;
                        const ALen: Integer=0;
                        const ADefault:string=''): string ;
    class function FStr(const AValue: string;
                        const ALen:Integer=0;
                        const AFix:Boolean=False;
                        const ADefault:string=''): string;
  public
    class function GetNumbers(const AValue: string): string	;
    class function GetUFSigla(const ACodMun: Integer): string	;
    //class function GetUFCod(const ACodMun: Integer): Word	;

    class function IsNumber(const AValue: string): Boolean	;

    class function CFOP_In(const cfop: Word; const values: array of Word): Boolean	;
    class function CFOP_IsST(const cfop: Word): Boolean	;

    class procedure IncValue(out AValBase: Currency; const AValInc: Currency) ;

  public
    class function ExtVal(var S: string): string ;
    class function ExtValCur(var S: string): Currency ;
    class function ExtValDat(var S: string): TDate ;
    class function ExtValInt(var S: string): Integer ;

  public
    const SEP_FIELD ='|';
  end;

implementation

uses DateUtils, StrUtils, Math ;


type
  Tcoduf_ibge = record
  public
    uf_codigo: Byte;
    uf_sigla : string;
  end;

const
  MAX_UF_IBGE = 27;
  UF_IBGE: array [0..MAX_UF_IBGE -1] of Tcoduf_ibge = (
    // reg. 10
    (uf_codigo: 11  ; uf_sigla: 'RO') ,
    (uf_codigo: 12  ; uf_sigla: 'AC') ,
    (uf_codigo: 14  ; uf_sigla: 'RR') ,
    (uf_codigo: 13  ; uf_sigla: 'AM') ,
    (uf_codigo: 15  ; uf_sigla: 'PA') ,
    (uf_codigo: 16  ; uf_sigla: 'AP') ,
    (uf_codigo: 17  ; uf_sigla: 'TO') ,
    // reg. 20
    (uf_codigo: 21  ; uf_sigla: 'MA') ,
    (uf_codigo: 22  ; uf_sigla: 'PI') ,
    (uf_codigo: 23  ; uf_sigla: 'CE') ,
    (uf_codigo: 24  ; uf_sigla: 'RN') ,
    (uf_codigo: 25  ; uf_sigla: 'PB') ,
    (uf_codigo: 26  ; uf_sigla: 'PE') ,
    (uf_codigo: 27  ; uf_sigla: 'AL') ,
    (uf_codigo: 28  ; uf_sigla: 'SE') ,
    (uf_codigo: 29  ; uf_sigla: 'BA') ,
    // reg. 30
    (uf_codigo: 31  ; uf_sigla: 'MG') ,
    (uf_codigo: 32  ; uf_sigla: 'ES') ,
    (uf_codigo: 33  ; uf_sigla: 'RJ') ,
    (uf_codigo: 35  ; uf_sigla: 'SP') ,
    // reg. 40
    (uf_codigo: 41  ; uf_sigla: 'PR') ,
    (uf_codigo: 42  ; uf_sigla: 'SC') ,
    (uf_codigo: 43  ; uf_sigla: 'RS') ,
    // reg. 50
    (uf_codigo: 50  ; uf_sigla: 'MS') ,
    (uf_codigo: 51  ; uf_sigla: 'MT') ,
    (uf_codigo: 52  ; uf_sigla: 'GO') ,
    (uf_codigo: 53  ; uf_sigla: 'DF')
    );


{ Tefd_util }

class function Tefd_util.AlignLeft(const ALen: Integer;
                                   const AStr: string;
                                   const AChar: Char): string;
begin
    Result :=Self.AlignStr(ALen, AStr, AChar, taLeftJustify) ;
end;

class function Tefd_util.AlignRight(const ALen: Integer;
                                   const AStr: string;
                                   const AChar: Char): string;
begin
    Result :=Self.AlignStr(ALen, AStr, AChar, taRightJustify) ;
end;

class function Tefd_util.AlignStr(const ALen: Integer;
                                  const AStr: string;
                                  const AChar: Char;
                                  const Align: TAlignment): string;
var
  C,M:integer;
begin
    Result :=Copy(AStr, 1, ALen) ;
    if ALen>0 then
  	begin
        C :=ALen - Length(Result) ;
        case Align of
            taLeftJustify  :Result :=Result + StringOfChar(AChar, C) ;
            taRightJustify :Result :=StringOfChar(AChar, C) + Result ;
            taCenter       :begin
                                M :=Trunc(C/2)	;
                                Result :=Self.AlignStr(ALen, StringOfChar(AChar, ALen)+Result, AChar) ;
                            end;
        end;
    end;
end;

class function Tefd_util.CFOP_In(const cfop: Word;
  const values: array of Word): Boolean;
var
  	I: Integer;
begin
    Result :=False;
  	for I :=Low(values) to High(values) do
    begin
        if cfop = values[I] then
        begin
          Result :=True	;
          Break;
        end;
    end;
end;

class function Tefd_util.CFOP_IsST(const cfop: Word): Boolean;
begin
    Result :=CFOP_In(cfop, [1401,
                            1403,
                            1406,
                            1407,
                            1408,
                            1409,
                            1410,
                            1411,
                            1414,
                            1415,
                            1603,
                            2401,
                            2403,
                            2406,
                            2407,
                            2408,
                            2409,
                            2410,
                            2411,
                            2414,
                            2415,
                            2603,
                            5403
                            ]);
end;

class function Tefd_util.ExtVal(var S: string): string;
var
  P: Word ;
begin
  P :=PosEx('|', S);
  case P of
    0:begin
        Result :=S ;
        S :='';
      end;
    1:begin
        if S[P+1]<>'|' then
        begin
          S :=Copy(S, P+1, Length(S)) ;
          P :=PosEx('|', S);
          Result :=Copy(S, 1, P-1) ;
          S :=Copy(S, P, Length(S));
        end
        else
        begin
          Result :='';
          S :=Copy(S, P+1, Length(S));
        end;
      end;
  else
    Result :=Copy(S, 1, P-1) ;
    S :=Copy(S, P+1, Length(S)) ;
  end;
end;

class function Tefd_util.ExtValCur(var S: string): Currency;
begin
  Result :=StrToCurrDef(ExtVal(S), 0)
  ;
end;

class function Tefd_util.ExtValDat(var S: string): TDate;
var
  V: string;
begin
  V :=ExtVal(S) ;
  Insert('/', V, 3) ;
  Insert('/', V, 6) ;
  Result :=StrToDateDef(V, 0) ;
end;

class function Tefd_util.ExtValInt(var S: string): Integer;
begin
  Result :=StrToIntDef(ExtVal(S), 0)
  ;
end;

class function Tefd_util.FBoo(const AValue: Boolean): string;
begin
    if AValue then
        Result := 'S'
    else
        Result := 'N';
end;

class function Tefd_util.FCur(const AValue: Currency;
                              const ADefault: string): string;
const
    FORMAT_CUR='0.00' ;
var
    f:TFormatSettings;
begin
    Result :='';
    f.DecimalSeparator :=',';
    if AValue > 0 then
    begin
        Result	:=SysUtils.FormatCurr(FORMAT_CUR, AValue, f);
    end
    else
    begin
        if ADefault<>'' then
        begin
            Result :=SysUtils.FormatCurr(FORMAT_CUR, StrToCurrDef(ADefault,0), f);
        end;
    end;
end;

class function Tefd_util.FDat(const AValue: TDateTime): string;
begin
    if YearOf(AValue)> 2005 then
        Result	:=FormatDateTime('DDMMYYYY', AValue)
    else
        Result	:='';
end;

class function Tefd_util.FFlt(const AValue: Extended;
                              const AFormat, ADefault: string): string;
var
    f:TFormatSettings;
begin
    Result :='';
    f.DecimalSeparator :=',';
    if AValue > 0 then
    begin
        Result	:=SysUtils.FormatFloat(AFormat, AValue, f);
    end
    else
    begin
        if ADefault<>'' then
        begin
            Result :=SysUtils.FormatFloat(AFormat, StrToFloatDef(ADefault,0), f);
        end;
    end;
end;

class function Tefd_util.FInt(const AValue: Integer;
                              const ALen: Integer;
                              const ADefault: string): string;
var
    I: Integer ;
begin
    I	:=Abs(AValue) ;
    if I>0 then
    begin
        Result :=IntToStr(I)  ;
        if ALen>0 then
        begin
            Result :=Self.AlignRight(ALen, Result) ;
        end;
    end
    else
    begin
        Result  :=ADefault  ;
    end;
end;

class function Tefd_util.FStr(const AValue: string;
                              const ALen: Integer;
                              const AFix:Boolean;
                              const ADefault: string): string;
begin
    Result :=Trim(AValue);
    if Result<>'' then
    begin
        if ALen>0 then
        begin
            if Length(Result)>=ALen then
            begin
                Result :=Self.AlignLeft(ALen, Result)  ;
            end
            else
            begin
                if AFix then
                begin
                    if Self.IsNumber(AValue) then
                        Result :=Self.AlignRight(ALen, Result)
                    else
                        Result :=Self.AlignLeft(ALen, Result);
                end;
            end;
        end ;
    end
    else
    begin
        Result :=ADefault ;
    end;
end;

class function Tefd_util.GetNumbers(const AValue: string): string;
var
    I:Integer	;
begin
  	Result	:='';
    for I:=1 to Length(AValue) do
    begin
        if AValue[I] in['0'..'9'] then
        begin
            Result :=Result +AValue[I]	;
        end;
    end;
end;


class function Tefd_util.GetUFSigla(const ACodMun: Integer): string;
var
    C: Byte ;
    I: Byte ;
begin
    Result :=IntToStr(ACodMun) ;
    Result :=Copy(Result, 1, 2);
    C :=StrToIntDef(Result, 0) ;
    Result :='' ;
    for I :=0 to MAX_UF_IBGE -1 do
    begin
        if UF_IBGE[I].uf_codigo = C then
        begin
            Result :=UF_IBGE[I].uf_sigla ;
            Break ;
        end;
    end;
end;

class procedure Tefd_util.IncValue(out AValBase: Currency; const AValInc: Currency);
begin
  AValBase :=AValBase +AValInc ;

end;

class function Tefd_util.IsNumber(const AValue: string): Boolean;
var
    S:String;
    I:Integer	;
begin
    S     :=Trim(AValue)  ;
  	Result:=Length(S)>0  ;
    if Result then
    begin
        for I:=1 to Length(S) do
        begin
            if not(S[I] in['0'..'9']) then
            begin
                Result	:=False ;
                Break ;
            end;
        end;
    end;
end;

end.
