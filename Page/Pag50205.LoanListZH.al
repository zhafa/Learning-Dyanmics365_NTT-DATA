page 50205 LoanList_ZH
{
    ApplicationArea = All;
    Caption = 'Loan List';
    PageType = List;
    SourceTable = LoanHeader_ZH;
    UsageCategory = Lists;
    CardpageID = "LoanCard_ZH";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the loan number', Comment = '%';
                }
                field(Employee; Rec.Employee)
                {
                    ToolTip = 'Specifies the employee who borrowed te equipment.', Comment = '%';
                }
                field(LoanDate; Rec.LoanDate)
                {
                    ToolTip = 'Specifies the date  the equipment is loaned.', Comment = '%';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ToolTip = 'Specifies the date the equipment is expected to be returned.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies whether the loan is open, released or returned.', Comment = '%';
                }
            }
        }
    }
}
