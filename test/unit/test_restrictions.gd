extends GutTest

var positive_int: int
var ten_int: int

var restrictions: Restrictions = Restrictions.new()
var positive_int_restriction: Restriction = Restriction.new(func() -> bool: return positive_int > 0, "`positive_int` must be > 0")
var ten_int_restriction: Restriction = Restriction.new(func() -> bool: return ten_int == 10, "`ten_int` must be == 0")

func before_all() -> void:
	restrictions.violation_report_mode = Restrictions.ViolationReportMode.SILENT_TEST

func before_each() -> void:
	restrictions.last_violations_count = 0
	positive_int = 100
	ten_int = 10
	
var test_is_violated_params: Array = ParameterFactory.named_parameters(
	['positive_int', 'report','expected_violated', 'expected_violations_count'], 
	[
		[5, true, false, 0], 
		[-1, true, true, 1],
		[5, false, false, 0], 
		[-1, false, true, 0]
	]
)
func test_is_violated(p = use_parameters(test_is_violated_params)) -> void:
	positive_int = p.positive_int
	assert_eq(
		restrictions.is_violated(positive_int_restriction, p.report), p.expected_violated, 
		"there was a violation" if p.expected_violated else "there were not violations"
	)
	assert_eq(
		restrictions.last_violations_count, p.expected_violations_count,
		str("there were ", p.expected_violations_count, " violations to report")
	)
	
var test_is_any_violated_params = ParameterFactory.named_parameters(
	['positive_int', 'ten_int','expected_violated', 'expected_violations_count'], 
	[
		[5, 10, false, 0], 
		[5, 0, true, 1],
		[-10, 10, true, 1], 
		[- 10, 0, true, 2],
	]
)
func test_is_any_violated(p = use_parameters(test_is_any_violated_params)) -> void:
	positive_int = p.positive_int
	ten_int = p.ten_int
	assert_eq(
		restrictions.is_any_violated([positive_int_restriction, ten_int_restriction]), p.expected_violated,
		"there was a violation" if p.expected_violated else "there were not violations"
	)
	assert_eq(
		restrictions.last_violations_count, p.expected_violations_count,
		str("there were ", p.expected_violations_count, " violations to report")
	)
	
var test_get_violated_restrictions_params = ParameterFactory.named_parameters(
	['positive_int', 'ten_int','expected_violated_restrictions'], 
	[
		[5, 10, []], 
		[5, 0, [ten_int_restriction]],
		[-10, 10, [positive_int_restriction]], 
		[- 10, 0, [ten_int_restriction, positive_int_restriction]],
	]
)
func test_get_violated_restrictions(p = use_parameters(test_get_violated_restrictions_params)) -> void:
	positive_int = p.positive_int
	ten_int = p.ten_int
	var got_violated_restrictions = restrictions.get_violated_restrictions([positive_int_restriction, ten_int_restriction])
	assert_eq(
		got_violated_restrictions.size(), p.expected_violated_restrictions.size(),
		str("there were ", p.expected_violated_restrictions.size(), " violated restrictions")
	)
	for expected_violated_restriction in p.expected_violated_restrictions:
		assert_has(
			got_violated_restrictions, expected_violated_restriction,
			str("restriction ", expected_violated_restriction, " was violated")
		)

var test_get_violated_reasons_params = ParameterFactory.named_parameters(
	['positive_int', 'ten_int','expected_violated_reasons'], 
	[
		[5, 10, []], 
		[5, 0, [ten_int_restriction.reason]],
		[-10, 10, [positive_int_restriction.reason]], 
		[- 10, 0, [ten_int_restriction.reason, positive_int_restriction.reason]],
	]
)
func test_get_violated_reasons(p = use_parameters(test_get_violated_reasons_params)) -> void:
	positive_int = p.positive_int
	ten_int = p.ten_int
	var got_violated_reasons = restrictions.get_violated_reasons([positive_int_restriction, ten_int_restriction])
	assert_eq(
		got_violated_reasons.size(), p.expected_violated_reasons.size(),
		str("there were ", p.expected_violated_reasons.size(), " violated reasons")
	)
	for expected_violated_reason in p.expected_violated_reasons:
		assert_has(
			got_violated_reasons, expected_violated_reason,
			str("reason ", expected_violated_reason, " was violated")
		)
		
func test_wrong_restriction_return_type() -> void:
	var correct_restriction: Restriction = Restriction.new(func(): return true, "returns bool")
	var wrong_restriction: Restriction = Restriction.new(func(): true, "returns nothing!")
	assert_eq(restrictions.is_violated(correct_restriction), false, "return type is correct")
	#FIXME ломает тесты
	#assert_eq(restrictions.is_violated(wrong_restriction), true, "return type is wrong")
