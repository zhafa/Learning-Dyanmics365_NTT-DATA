page 50201 EquipmentCard_ZH
{
    ApplicationArea = All;
    Caption = 'Equipment Card';
    PageType = Card;
    SourceTable = Equipment_ZH;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the unique code of the equipment. It is filled in automatically from the number series.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the equipment.';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the category of the equipment, such as laptop, projector or vehicle.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies whether the equipment is available, on loan or under maintenance.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies that the equipment cannot be used in new loans.';
                }
            }
        }
    }
}