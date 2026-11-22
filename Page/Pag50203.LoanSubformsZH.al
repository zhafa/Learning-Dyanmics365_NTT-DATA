page 50203 LoanSubforms_ZH
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = LoanLine_ZH;
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EquipmentCode; Rec.EquipmentCode)
                {
                    ToolTip = 'Specifies the equipment to be loaned.';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ToolTip = 'Specifies the description of the equipment. It is filled in automatically.';
                }
                field("Condition on Loan"; Rec."Condition on Loan")
                {
                    ToolTip = 'Specifies the condition of the equipment at the time it is loaned.';
                }
            }
        }
    }
}