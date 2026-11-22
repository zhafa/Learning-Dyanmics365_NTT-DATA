codeunit 50200 LoanEventSubscribers_ZH
{
    // Pengcekan apakah karyawan punya pinjaman release yang melewati batas waktu maksimal pengembalian.
    procedure HasOverdueLoan(EmployeeNo: Code[20]):Boolean
    var
        LoanHeader: Record LoanHeader_ZH;
    begin
        LoanHeader.SetRange(Employee, EmployeeNo);
        LoanHeader.SetRange(Status, LoanHeader.Status::Released);
        LoanHeader.SetFilter("Expected Return Date", '<>%1&<%2',0D, WorkDate());
        exit(not LoanHeader.IsEmpty());
    end;

    // Case 1: Karyawan dengan pinjaman yang overdue tidak boleh membuat pinjaman baru
    [EventSubscriber(ObjectType::Table, Database::LoanHeader_ZH, 'OnBeforeValidateEvent', 'Employee', false, false)]
    local procedure BlockNewLoanForOverdueEmployee(var Rec: Record LoanHeader_ZH; var xRec: Record LoanHeader_ZH; CurrFieldNo:Integer)
    var 
        OverdueErr: Label 'Employee %! has overdue loans and cannot create a new load. Return overdue equipment first.';
    begin   
        if Rec.Employee = '' then
        exit;
        if HasOverdueLoan(Rec.Employee) then 
            Error(OverdueErr, Rec.Employee);
    end;
        
    // Case 2: Employee tidak boleh dihapus selama masih punya pinjaman aktif secara hard code
    [EventSubscriber(ObjectType::Table, Database::Employee, 'OnBeforeDeleteEvent', '',false, false)]
    local procedure BlockEmployeeDeleteWithActiveLoan (Var Rec: Record Employee; RunTrigger: Boolean)
    var
        LoanHeader: Record LoanHeader_ZH;
        ActiveLoanErr: Label 'Employee %1 cannot be deleted because there are loans that have not been returned.';
    begin
        if Rec.IsTemporary() then
        exit;

        LoanHeader.SetRange(Employee, Rec."No.");
        LoanHeader.SetRange(Status, LoanHeader.Status::Released);
        if not LoanHeader.IsEmpty() then
            Error(ActiveLoanErr, Rec."No.");
    end;
}
