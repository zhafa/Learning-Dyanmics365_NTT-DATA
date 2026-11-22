pageextension 50200 EquipmentRoleCenter extends "Business Manager Role Center"
{
    actions
    {
       addlast (Embedding)
       {
            action (EquipmentList)
            {
            ApplicationArea = All;
            Caption = 'Equipment';
            runObject = page "EquipmentList_ZH";
            tooltip = 'Open the list of equipment that employee can borrow.';
         
            }
        }
    }
}
