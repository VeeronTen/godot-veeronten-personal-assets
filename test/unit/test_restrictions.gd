extends GutTest

var positive_int_reason: String = "`positive_int` must be > 0"
var ten_int_reason: String = "`ten_int` must be == 0"

var restrictions: Restrictions = Restrictions.new().add_restriction(
	Restriction.new(func() -> bool: return positive_int > 0, positive_int_reason)
).add_restriction(
	Restriction.new(func() -> bool: return ten_int == 10, ten_int_reason)
)
var not_prefilled_restrictions: Restrictions
var positive_int: int
var ten_int: int

func before_all() -> void:
	restrictions.violation_report_mode = Restrictions.ViolationReportMode.SILENT_TEST

func before_each() -> void:
	positive_int = 100
	ten_int = 10
	not_prefilled_restrictions = Restrictions.new()
	not_prefilled_restrictions.violation_report_mode = Restrictions.ViolationReportMode.SILENT_TEST
	
func test_no_violations_by_default() -> void:
	assert_eq(restrictions.last_violations_count, 0, "there was no violation")
	assert_eq(restrictions.get_failed_texts(), [], "failed texts should be empty")
	
func test_no_violations() -> void:
	restrictions.check_restrictions()
	assert_eq(restrictions.last_violations_count, 0, "there was no violation")
	assert_eq(restrictions.get_failed_texts(), [], "failed texts should be empty")
	
func test_violation() -> void:
	positive_int = -1
	restrictions.check_restrictions()
	assert_eq(restrictions.last_violations_count, 1, "there was a violation")
	assert_eq(restrictions.get_failed_texts(), [positive_int_reason], "failed texts have to contain `positive_int_reason`")
	
func test_two_violations() -> void:
	positive_int = -1
	ten_int = 1000000
	restrictions.check_restrictions()
	assert_eq(restrictions.last_violations_count, 2, "there were two violations")
	assert_eq(restrictions.get_failed_texts(), [positive_int_reason, ten_int_reason], "failed texts have to contain `positive_int_reason` and `ten_int_reason`")

func test_wrong_restriction_return_type() -> void:
	@warning_ignore("return_value_discarded")
	not_prefilled_restrictions.add_restriction(Restriction.new(func() -> void:, "wrong return type"))
	assert_eq(not_prefilled_restrictions.last_violations_count, 1, "the return type of restrictions must be bool")
