page 50207 PostedLoanCard_ZH
{
    ApplicationArea = All;
    Caption = 'Posted Loan';
    PageType = Document;
    SourceTable = PostedLoanHeader_ZH;
    Editable = false;
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";Rec."No.")
                {
                   ToolTip = 'Specifies the loan number. It is assigned automatically from the number series.';
                }

                field(Employee;Rec.Employee)
                {
                    ToolTip = 'Specifies the employee who borrowed the equipment.';
                }                
                field(LoanDate;Rec.LoanDate)
                {
                    ToolTip = 'Specifies the date the equipment is loaned.';
                }
                field("Expected Return Date";Rec."Expected Return Date")
                {
                    ToolTip = 'Specifies the date the equipment is expected to be returned.';
                }
                field(Status;Rec.Status)
                {
                    ToolTip = 'Specifies whether the loan is open, released or returned.';
                }
                field("Actual Return Date";Rec."Actual Return Date")
                {
                    ToolTip = 'Specifies the date the equipment was actually returned.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the value of the first global dimension.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the value of the second global dimension.';
                }
            }
            part(Lines; PostedLoanSubform_ZH)
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = Field("No.");
            }
        }
    }
}
