page 50202 EquipmentSetup_ZH
{
    ApplicationArea = All;
    Caption = 'Equipment Setup';
    PageType = Card;
    usagecategory = Administration;
    SourceTable = EquipmentSetup_ZH;
    
    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                
                field("Equipment Nos."; Rec."Equipment Nos.")
                {
                    ToolTip = 'Specifies the value of the Equipment Nos. field.', Comment = '%';
                }
                field("Loan  Nos."; Rec."Loan Nos.")
                {
                    ToolTip = 'Specifies the number series used to assign numbers to new loan documents', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.GetSetup();
    end;
}
