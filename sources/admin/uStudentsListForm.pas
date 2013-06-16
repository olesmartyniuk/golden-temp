unit uStudentsListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TStudentListForm = class(TForm)
    ListViewStudents: TListView;
    PanelBottom: TPanel;
    ButtonSelect: TButton;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    LabelInfo: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonSelectClick(Sender: TObject);
  private
    { Private declarations }
  public
    SelectedIndexes: array of integer;
    Select: boolean;
  end;

var
  StudentListForm: TStudentListForm;

implementation

uses
  uMainUnit;

{$R *.dfm}

procedure TStudentListForm.ButtonCancelClick(Sender: TObject);
begin
  SetLength(SelectedIndexes, 0);
end;

procedure TStudentListForm.ButtonOkClick(Sender: TObject);
var
  i: integer;
  item: TListItem;
begin
  SetLength(SelectedIndexes, 0);
  for i := 0 to ListViewStudents.Items.Count - 1 do
    begin
    item := ListViewStudents.Items[i];
    if item.Selected then
      begin
      SetLength(SelectedIndexes, Length(SelectedIndexes) + 1);
      SelectedIndexes[High(SelectedIndexes)] := item.Index;
      end;
    end;
end;

procedure TStudentListForm.ButtonSelectClick(Sender: TObject);
begin
  ListViewStudents.SelectAll;
  ListViewStudents.SetFocus; 
end;

procedure TStudentListForm.FormShow(Sender: TObject);
begin
 ListViewStudents.Items.Assign(AdministratorMainForm.ListViewStudents.Items);
 Select := False;
end;

end.
