class TermsController < ApplicationController
  before_action do
    authenticate_user!
    set_group
    set_show

    add_breadcrumb "Groups", groups_url
    add_breadcrumb @group.name, group_url(@group)
    add_breadcrumb "Shows", group_shows_url(@group)
    add_breadcrumb @show.name, group_show_url(@group, @show)
  end

  def new
    @term = Term.new
  end

  def create
    @term = Term.new(term_params)
    @term.show = @show

    if @term.save
      redirect_to group_show_url(@group, @show)
    else
      render 'new'
    end
  end

  def destroy
    @term = @show.terms.find(params[:id])

    if @term.destroy
      redirect_to group_show_url(@group, @show), notice: "Term `#{@term.name}` removed."
    else
      redirect_to group_show_url(@group, @show), alert: "Term could not be removed."
    end
  end

  private
    def term_params
      params.require(:term).permit(:name)
    end
end
