page 50208 PostedLoanList_ZH
{
    ApplicationArea = All;
    Caption = 'Posted Loan List';
    PageType = List;
    SourceTable = PostedLoanHeader_ZH;
    UsageCategory = History;
    CardPageId = PostedLoanCard_ZH;
    Editable = false;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No.";Rec."No.")
                {
                    ToolTip = 'Specifies the loan number.';
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
                    ToolTip = 'Specifies the date the equipment was returned.';
                }
            }
        }
    }
}
