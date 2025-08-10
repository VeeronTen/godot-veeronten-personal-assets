class_name Restrictions
extends RefCounted

enum ViolationReportMode { ASSERT, PUSH_ERROR, SILENT_TEST }

var violation_report_mode: ViolationReportMode = ViolationReportMode.ASSERT
var last_violations_count: int = 0

func is_violated(restriction: Restriction, _report: bool = true) -> bool:
	var condition_result: bool = restriction.condition.call()
	if condition_result is not bool: 
		_report_violations(["all restrictions have to return bool"])
		return true
	var is_condition_violated: bool = not condition_result
	if is_condition_violated and _report: _report_violations([restriction.reason])
	return is_condition_violated

func is_any_violated(restrictions: Array[Restriction]) -> bool:
	var violated_reasons: Array[String] = get_violated_reasons(restrictions)
	var is_any_condition_violated: bool = not violated_reasons.is_empty()
	if is_any_condition_violated: _report_violations(violated_reasons)
	return is_any_condition_violated

func get_violated_restrictions(restrictions: Array[Restriction]) -> Array[Restriction]:
	return restrictions.filter(
		func(restriction: Restriction) -> bool: return is_violated(restriction, false)
	)
	
func get_violated_reasons(restrictions: Array[Restriction]) -> Array[String]: 
	var violated_reasons: Array[String]
	violated_reasons.assign(
		get_violated_restrictions(restrictions).map(
			func(restriction: Restriction) -> String: return restriction.reason
		)
	)
	return violated_reasons
	
func _report_violations(reasons: Array[String]) -> void:
	last_violations_count = reasons.size()
	var report_message: String = " +++ ".join(reasons)
	match violation_report_mode:
		ViolationReportMode.ASSERT: assert(false, report_message)
		ViolationReportMode.PUSH_ERROR: push_error(report_message)
		ViolationReportMode.SILENT_TEST: pass
		_: assert(false, "unknown ViolationReportMode type")
