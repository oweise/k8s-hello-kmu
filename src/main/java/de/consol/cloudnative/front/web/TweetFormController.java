package de.consol.cloudnative.front.web;

import de.consol.cloudnative.data.model.Tweet;
import de.consol.cloudnative.service.TweetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import javax.validation.Valid;

@Controller
@RequestMapping("/tweet-form")
public class TweetFormController {

    @Autowired
    private TweetService tweetService;

    @GetMapping
    public ModelAndView showIndex(final Model model) {
        model.addAttribute("detailView", "layouts/tweet-form-layout");
        model.addAttribute("detailSelector", "layout");
        return new ModelAndView("index", "tweet", new Tweet());
    }

    @RequestMapping(value = "/addTweet", method = RequestMethod.POST)
    public RedirectView submit(@Valid @ModelAttribute("tweet") Tweet tweet,
                            BindingResult result, ModelMap model) {
        tweetService.addNewTweet(tweet);
        return new RedirectView("/");
    }

}
