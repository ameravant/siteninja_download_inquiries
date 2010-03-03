class DownloadInquiriesController < InquiriesController
  add_breadcrumb "Home", "root_path"
  before_filter :find_page
  def index
    render :new
  end
  def new
    @download_inquiry = DownloadInquiry.new
    add_breadcrumb @page.name, nil
    @person = Person.new
    @groups = PersonGroup.only_public
    if params[:download_inquiry]
      @person.first_name = params[:download_inquiry][:first_name] unless params[:download_inquiry][:first_name].blank?
      @person.last_name = params[:download_inquiry][:last_name] unless params[:download_inquiry][:last_name].blank?
      @download_inquiry.email = params[:download_inquiry][:email] unless params[:download_inquiry][:email].blank?
      @download_inquiry.inquiry = "Requesting Download."
    end
  end
 
  def create
    return unless params[:company].blank? # spam bots will fill this hidden field out
    params[:person][:email] = params[:download_inquiry][:email]
    #this check occurs to make sure people cannot set themselves to unauthorized groups
    #valid_groups = params[:person][:person_group_ids].reject{|p| !@groups.collect(&:id).include?(p)}
    @person = Person.find_or_create_by_email(params[:person])
    if !@person.valid?
      flash[:error] = "Please enter your first and last name"
      @download_inquiry = DownloadInquiry.new(params[:download_inquiry])
      render :action => 'new'
    else
      if params[:person][:person_group_ids]
        @person.person_group_ids |= params[:person][:person_group_ids].collect{|i| i.to_i}
      end
      @person.save
      params[:download_inquiry][:name] ="#{params[:person][:first_name]} #{params[:person][:last_name]}"
      params[:download_inquiry][:person_id] = @person.id
      @download_inquiry = DownloadInquiry.new(params[:download_inquiry])
      if !@download_inquiry.save
        render :action => "new"
      else
        redirect_to "/"
        flash[:notice] = "Message sent!"
      end
    end
  end
  private
  def find_page
    @page = Page.find_by_permalink("download-inquiries")
  end
end