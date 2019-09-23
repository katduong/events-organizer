package com.codingdojo.events.services;

import java.util.List;
import java.util.Optional;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import com.codingdojo.events.models.Event;
import com.codingdojo.events.models.Message;
import com.codingdojo.events.models.User;
import com.codingdojo.events.repositories.EventRepository;
import com.codingdojo.events.repositories.MessageRepository;
import com.codingdojo.events.repositories.UserRepository;

@Service
public class UEService {
	private final UserRepository userRepository;
	private final EventRepository eventRepository;
	private final MessageRepository messageRepository;
	
    public UEService(UserRepository userRepository, EventRepository eventRepository, MessageRepository messageRepository) {
        this.userRepository = userRepository;
        this.eventRepository = eventRepository;
        this.messageRepository = messageRepository;
    }
    
 // register user and hash their password
    public User registerUser(User user) {
        String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        user.setPassword(hashed);
        return userRepository.save(user);
    }
    
    // find user by email
    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    
    // find user by id
    public User findUserById(Long id) {
    	Optional<User> u = userRepository.findById(id);
    	
    	if(u.isPresent()) {
            return u.get();
    	} else {
    	    return null;
    	}
    }
    
    // authenticate user
    public boolean authenticateUser(String email, String password) {
        // first find the user by email
        User user = userRepository.findByEmail(email);
        // if we can't find it by email, return false
        if(user == null) {
            return false;
        } else {
            // if the passwords match, return true, else, return false
            if(BCrypt.checkpw(password, user.getPassword())) {
                return true;
            } else {
                return false;
            }
        }
    }
    
    // create event
    public Event createEvent(Event event, User user) {
    	event.setHost(user);
    	return eventRepository.save(event);
    }
    
    // find all events in user's area
    public List<Event> eventsInState(String state) {
    	return eventRepository.findEventsInState(state);
    }
    
    // find all events outside of user's state
    public List<Event> eventsOutOfState(String state) {
    	return eventRepository.findEventsInOtherStates(state);
    }
    
    // add event
    public void attendEvent(Long id, Long userid) {
    	User user = userRepository.findById(userid).get();
    	Event e = eventRepository.findById(id).get();
    	user.getEventsAttending().add(e);
    	userRepository.save(user);
    }
    
    // remove event from events attending
    public void unattendEvent(Long id, Long userid) {
    	User user = userRepository.findById(userid).get();
    	Event e = eventRepository.findById(id).get();
    	user.getEventsAttending().remove(e);
    	userRepository.save(user);
    }
    
    // delete event
    public void deleteEvent(Long id) {
    	eventRepository.deleteById(id);
    }
    
    // find event by id
    public Event findEvent(Long id) {
    	return eventRepository.findById(id).get();
    }
    
    // create a message
    public Message createMessage(Message m) {
    	return messageRepository.save(m);
    }
    
    
    
}
