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
                field("Actual Return Date"; Rec."Actual Return Date")
                {   
                    Editable = false;
                    ToolTip = 'Specifies the date the equipment was actually returned.';
                }

                // Menambahkan Shorcut untuk dimension 1
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Tooltip = 'Specifies the value of the first global dimension for the loan.';
                }
                // Menambahkan Shorcut untuk dimension 2                
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Tooltip = 'Specifies the value of the second global dimension for the loan';
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
                Enabled = IsReleased;
                ToolTip = 'Reopen the loan so it can be edited again.';

                trigger OnAction()
                begin
                    Rec.Reopen();
                    CurrPage.Update(false);
                end;
            }
            action(Return)
            {
                ApplicationArea = all;
                Caption = 'Return';
                Image = Return;
                Enabled = IsReleased;
                Tooltip = 'Record that the equipment has been returned and make it available again.';

                Trigger OnAction()
                var
                    ReturnedMsg: Label 'Loan No. %1 has been returned and archived';
                begin
                    Rec.return();
                    Message(ReturnedMsg,Rec."No.");
                    CurrPage.Close();
                end;
            }
            
            // Pembuatan button action untuk dimensions
            action(Dimensions)
            {
                AccessByPermission = tabledata Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                Enabled = Rec."No." <> '';
                // Cara memasang shorcut kalau perlu aja
                // ShortcutKey = 'Alt+D';
                ToolTip = 'View or edit the dimension of the loan.';
                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                    CurrPage.SaveRecord();
                end;
            }
        }
        area(Promoted)
        {
            actionref(Release_Promoted; Release) { }
            actionref(Reopen_Promoted; Reopen) { }
            actionref(Return_Promoted; Return) { }
            actionref(Dimensions_Promoted; Dimensions) { }
        }
    }

    var
        IsOpen: Boolean;
        IsReleased: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        IsOpen := Rec.Status = Rec.Status::Open;
        IsReleased := Rec.Status = Rec.Status::Released;
    end;
}