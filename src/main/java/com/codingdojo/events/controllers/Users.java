package com.codingdojo.events.controllers;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.codingdojo.events.models.Event;
import com.codingdojo.events.models.User;
import com.codingdojo.events.services.UEService;
import com.codingdojo.events.validator.UserValidator;

@Controller
public class Users {
	private final UEService userService;
	private final UserValidator userValidator;
    
    public Users(UEService userService, UserValidator userValidator) {
        this.userService = userService;
        this.userValidator = userValidator;
    }

    @RequestMapping("")
    public String signIn(@ModelAttribute("user") User user) {
    	return "index.jsp";
    }
    
    @RequestMapping(value="/registration", method=RequestMethod.POST)
    public String registerUser(@Valid @ModelAttribute("user") User user, BindingResult result, HttpSession session) {
        // if result has errors, return the registration page (don't worry about validations just now)
    	userValidator.validate(user, result);
    	if (result.hasErrors()) {
    		return "index.jsp";
    	}
        // else, save the user in the database, save the user id in session, and redirect them to the /home route
    	else {
    		User newUser = userService.registerUser(user);
    		session.setAttribute("id", newUser.getId());
    		return "redirect:events";
    	}
    }
    
    @RequestMapping(value="/login", method=RequestMethod.POST)
    public String loginUser(@RequestParam("email") String email, @RequestParam("password") String password, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        // if the user is authenticated, save their user id in session
    	if (userService.authenticateUser(email, password)) {
    		User user = userService.findByEmail(email);
    		session.setAttribute("id", user.getId());
    		return "redirect:events";
    	}
        // else, add error messages and return the login page
    	else {
    		redirectAttributes.addFlashAttribute("error", "User could not be authenticated, please try again.");
    		return "redirect:/";
    	}
    }
    
    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        // invalidate session
    	session.invalidate();
        // redirect to login page
    	return "redirect:/";
    }
    
    
}
