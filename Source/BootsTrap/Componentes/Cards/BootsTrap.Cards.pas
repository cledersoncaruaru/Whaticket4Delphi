unit BootsTrap.Cards;

interface

uses

SysUtils,
Classes,
System.StrUtils,
Buttons.Icons,
Functions.Strings;

   Function Get_Card(Title:string; Valor:string; Color:string; Icone:string):String;




implementation

Function Get_Card(Title:string; Valor:string; Color:string; Icone:string):String;
var
Lista:TStringList;
begin

  Lista:= TStringList.Create;

  try

    Lista.Add(
      '  <div class="card card-dashboard ' + Color + ' text-white mb-3">' +
      '    <div class="card-body py-3 d-flex align-items-center">' +
      '      <div class="me-3">' +
      '        <i class="' + Icone + ' fa-2x"></i>' +
      '      </div>' +
      '      <div class="flex-grow-1">' +
      '        <div class="fs-4 fw-bold">' + Valor + '</div>' +
      '        <div class="fs-6">' + Title + '</div>' +
      '      </div>' +
      '    </div>' +
      '  </div>'
    );

   Result  := Lista.Text;


  finally
  Lista.Free;
  end;

end;


end.
