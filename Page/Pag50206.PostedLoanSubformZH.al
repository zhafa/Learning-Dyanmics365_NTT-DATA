page 50206 PostedLoanSubform_ZH
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = PostedLoanLine_ZH;
    Editable = false;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EquipmentCode;Rec.EquipmentCode)
                {
                    ToolTip = 'Specifies the equipment to be loaned.';
                }
                field(Description;Rec.Description)
                {
                    ToolTip = 'Specifies the description of the equipment. It is filled in automatically.';
                }
                field("Condition on Loan";Rec."Condition on Loan")
                {
                    Tooltip = 'Specifies the condition of the equipment at the time it is loaned.';
                }
            }
        }
    }
}
