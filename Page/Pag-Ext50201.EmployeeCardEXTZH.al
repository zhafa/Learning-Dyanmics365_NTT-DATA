pageextension 50201 "EmployeeCardEXT_ZH " extends "Employee Card"
{
    layout 
    {
        addlast(General)
        {
            field("Equipment On Loan"; Rec."Equipment On Loan")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many pieces of equipment this employee is currently borrowing.';
            }
        }
    }
}
