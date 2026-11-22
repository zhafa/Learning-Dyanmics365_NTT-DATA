page 50200 EquipmentList_ZH
{
    ApplicationArea = All;
    Caption = 'Equipment List';
    PageType = List;
    SourceTable = Equipment_ZH;
    CardPageId = "EquipmentCard_ZH";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the unique code of the equipment.';
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