class HomeController < ApplicationController
  before_action :require_user, except: [:index]

  # this is here so that we can present some basic "about this application"
  # information about the PTA directory
  
  def index
    if logged_in?
      redirect_from_root_for_logged_in
    end
  end

  def freshuser
  end

  def search

    @search_results = []
    
    if params[:search]
      # here we are looking for almost any string among our data set

      search_classes = [Family, Parent, Student, Teacher, Schoolclass, Address, Contact]

      unfolded_search_results = search_classes.inject([]) { |memo, directory_class| memo + directory_class.search_for(params[:search]) }

      # we need to treat contacts and addresses as special.
      # what we do is "fold" the results of addresses to match against the
      # addressable family or parent
      # and similarly contacts fold to teachers or parents
      @search_results = fold_search_results_for_contacts_and_addresses(unfolded_search_results)
    end 
  end

  def developer
  end

  def administer_families
  end

  private

  def fold_search_results_for_contacts_and_addresses(search_results)
    
    search_set = Set.new

    search_results.each do |entry|
      if (entry.class == Address)
        search_set << entry.addressable
      elsif (entry.class ==  Contact)
        search_set << entry.contactable
      else
        search_set << entry
      end
    end

    # return an array form of the set
    search_set.to_a

  end

end
