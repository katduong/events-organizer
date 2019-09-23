package com.codingdojo.events.controllers;

import java.util.List;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.codingdojo.events.models.Event;
import com.codingdojo.events.models.Message;
import com.codingdojo.events.models.User;
import com.codingdojo.events.services.UEService;
import com.codingdojo.events.validator.EventValidator;

@Controller
@RequestMapping("/events")
public class Events {
	private final UEService userService;
	private final EventValidator eventValidator;

	public Events(UEService userService, EventValidator eventValidator) {
		this.userService = userService;
		this.eventValidator = eventValidator;
	}
	@RequestMapping("")
    public String home(HttpSession session, Model model, @ModelAttribute("event") Event event) {
        // get user from session, save them in the model and return the home page
    	Long id = (Long)session.getAttribute("id");
    	if (id == null) {
    		return "redirect:/";
    	}
    	User user = userService.findUserById(id);
    	List<Event> eventsInState = userService.eventsInState(user.getState());
    	List<Event> eventsOutState = userService.eventsOutOfState(user.getState());
    	model.addAttribute("user", user);
    	model.addAttribute("eventsInState", eventsInState);
    	model.addAttribute("eventsInOtherStates", eventsOutState);
    	for (Event e : eventsInState) {
    		System.out.printf("Event: %s, host: ", e.getName());
    	}
    	return "events.jsp";
    }
	@RequestMapping(value="/create", method=RequestMethod.POST)
	public String createEvent(@Valid @ModelAttribute("event") Event event, BindingResult result, HttpSession session, Model model) {
		eventValidator.validate(event, result);
		if (result.hasErrors()) {
			Long id = (Long)session.getAttribute("id");
			User user = userService.findUserById(id);
	    	List<Event> eventsInState = userService.eventsInState(user.getState());
	    	List<Event> eventsOutState = userService.eventsOutOfState(user.getState());
	    	model.addAttribute("user", user);
	    	model.addAttribute("eventsInState", eventsInState);
	    	model.addAttribute("eventsInOtherStates", eventsOutState);
			return "events.jsp";
		}
		else {
			Long id = (Long) session.getAttribute("id");
	    	User user = userService.findUserById(id);
			userService.createEvent(event, user);
			return "redirect:/events";
		}
	}
	
	@RequestMapping("/{id}")
	public String showEvent(@PathVariable("id") Long id, Model model, @ModelAttribute("message") Message message, HttpSession session) {
		Long userid = (Long) session.getAttribute("id");
		if (userid == null) {
			return "redirect:/";
		}
    	User user = userService.findUserById(userid);
    	model.addAttribute("user", user);
		Event event = userService.findEvent(id);
		model.addAttribute("event", event);
		return "showEvent.jsp";
	}
	@PostMapping("/{id}/addMessage")
	public String addMessage(@PathVariable("id") Long id, @Valid @ModelAttribute("message") Message message, BindingResult result) {
		if (result.hasErrors()) {
			return "showEvent.jsp";
		}
		else {
			userService.createMessage(message);
			return "redirect:/events/" + id;
		}
	}
	@RequestMapping("/{id}/edit")
	public String edit(@PathVariable("id") Long id, @ModelAttribute("e") Event e, Model model, HttpSession session) {
		Long userid = (Long)session.getAttribute("id");
    	if (userid == null) {
    		return "redirect:/";
    	}
		Event event = userService.findEvent(id);
		model.addAttribute("event", event);
		return "editEvent.jsp";
	}
	
	@PutMapping("/{id}/edit")
	public String editEvent(@PathVariable("id") Long id, @Valid @ModelAttribute("e") Event e, BindingResult result, HttpSession session, Model model) {
		if (result.hasErrors()) {
			Event event = userService.findEvent(id);
			model.addAttribute("event", event);
			return "editEvent.jsp";
		}
		else {
			Long userid = (Long) session.getAttribute("id");
	    	User user = userService.findUserById(userid);
			userService.createEvent(e, user);
			return "redirect:/events/" + id;
		}		
		
	}
	@RequestMapping("/{id}/join")
	public String joinEvent(@PathVariable("id") Long id, HttpSession session) {
		Long userid = (Long) session.getAttribute("id");
		userService.attendEvent(id, userid);
		return "redirect:/events";
	}
	@RequestMapping("/{id}/cancel")
	public String unjoinEvent(@PathVariable("id") Long id, HttpSession session) {
		Long userid = (Long) session.getAttribute("id");
		userService.unattendEvent(id, userid);
		
		return "redirect:/events";
	}
	@RequestMapping("/{id}/delete")
	public String deleteEvent(@PathVariable("id") Long id) {
		userService.deleteEvent(id);
		return "redirect:/events";
	}
	
}

