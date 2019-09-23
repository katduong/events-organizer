package com.codingdojo.events.validator;

import java.util.Date;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.codingdojo.events.models.Event;

@Component
public class EventValidator implements Validator{
	@Override
	public boolean supports(Class<?> clazz) {
		return Event.class.equals(clazz);
	}
	
	@Override
	public void validate(Object target, Errors errors) {
		Date now = new Date();
		Event event = (Event) target;
		if (event.getDate() != null) {
			if (event.getDate().compareTo(now) < 0) {
				errors.rejectValue("date", "dateGreater");
			}
		}
	}
}
