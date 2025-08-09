class_name Restrictions
extends RefCounted

enum ViolationReportMode { ASSERT, PUSH_ERROR, SILENT_TEST }

var violation_report_mode: ViolationReportMode = ViolationReportMode.ASSERT
var last_violations_count: int = 0

var _restrictions_list: Array[Restriction]
	
func add_restriction(new_restriction: Restriction) -> Restrictions:
	if new_restriction.condition.call() is not bool:
		report_violations(["all restrictions have to be () -> bool"])
	else:
		_restrictions_list.append(new_restriction)
	return self
	
func get_failed_texts() -> Array[String]: 
	var failed_texts: Array[String]
	failed_texts.assign(
		_restrictions_list.filter(
			func(restriction: Restriction) -> bool: return not restriction.condition.call()
		).map(
			func(restriction: Restriction) -> String: return restriction.reason
		)
	)
	return failed_texts

func check_restrictions() -> void:
	var failed_texts: Array[String] = get_failed_texts()
	if not failed_texts.is_empty(): report_violations(failed_texts)

func report_violations(violations: Array[String]) -> void:
	last_violations_count = violations.size()
	var report_message: String = "- " + "\n- ".join(violations)
	match violation_report_mode:
		ViolationReportMode.ASSERT: assert(false, report_message)
		ViolationReportMode.PUSH_ERROR: push_error(report_message)
		ViolationReportMode.SILENT_TEST: pass
		_: assert(false, "unknown ViolationReportMode type")
