page 50204 LoanCard_ZH
{
    ApplicationArea = All;
    Caption = 'Loan Card';
    PageType = Document;
    SourceTable = LoanHeader_ZH;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = IsOpen;

                field("No."; Rec."No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the loan number. It is assigned automatically from the number series.';
                }
                field(Employee; Rec.Employee)
                {
                    ToolTip = 'Specifies the employee who borrowed the equipment.';
                }
                field(LoanDate; Rec.LoanDate)
                {
                    ToolTip = 'Specifies the date the equipment is loaned.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ToolTip = 'Specifies the date the equipment is expected to be returned.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies whether the loan is open, released or returned.';
                }
            }
            part(Lines; "LoanSubforms_ZH")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Document no." = field("No.");
                UpdatePropagation = Both;
                Editable = IsOpen;
            }
        }
    }

    //Membuat dua tombol di Loan Card, yaitu Release dan Reopen, yang mengatur status dokumen peminjaman dan mengunci atau membuka kembali isinya
    actions
    {
        area(Processing)
        {
            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release';
                Image = ReleaseDoc;
                Enabled = IsOpen;
                ToolTip = 'Release the loan so the equipment can be handed over.';

                trigger OnAction()
                begin
                    Rec.Release();
                    CurrPage.Update(false);
                end;
            }
            action(Reopen)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Image = ReOpen;
                Enabled = not IsOpen;
                ToolTip = 'Reopen the loan so it can be edited again.';

                trigger OnAction()
                begin
                    Rec.Reopen();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Release_Promoted; Release) { }
            actionref(Reopen_Promoted; Reopen) { }
        }
    }

    var
        IsOpen: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        IsOpen := Rec.Status = Rec.Status::Open;
    end;
}