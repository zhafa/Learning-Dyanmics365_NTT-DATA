tableextension 50200 EmployeeEXT_ZH extends Employee
{
    fields
    {
        field(50200; "Equipment On Loan"; Integer )
        {
            Caption = 'Equipment On Loan';
            FieldClass = FlowField;
            CalcFormula = count(Equipment_ZH where("Current Holder" = field("No."), Status = Const("Loan")));
            Editable = false;
        }
    }
}
