package com.springapp.mvc;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HelloController {
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String printWelcome(ModelMap model) {
		model.addAttribute("message", "Hello world!2222");
		return "hello";
	}

    @RequestMapping(value = "/test/{Action}", method = RequestMethod.GET)
    public String printWelcome2(@PathVariable String Action) {
        ModelMap result = new ModelMap();

        result.addAttribute("message", "Hello world!2"+Action);
        System.out.print("response : "+Action);
        return "hello";
    }
}