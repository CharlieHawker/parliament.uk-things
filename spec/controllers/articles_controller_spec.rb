require 'rails_helper'

RSpec.describe ArticlesController, vcr: true do
  describe 'GET show' do
    context 'variable assignment' do
      context 'when successful' do
        before(:each) do
          get :show, params: { article_id: 'ccdwcKYM' }
        end
        it 'should have a response with a http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'assigns @article as a Grom::Node' do
          expect(assigns(:article)).to be_a(Grom::Node)
        end

        it 'assigns @article as a Grom::Node of type Article' do
          expect(assigns(:article).type).to eq('https://id.parliament.uk/schema/WebArticle')
        end

        it 'assigns @article to the article with correct id' do
          expect(assigns(:article).graph_id).to eq('ccdwcKYM')
        end

        it 'assigns @root_collections as an array' do
          expect(assigns(:root_collections).to be_a(Array))
        end

        it 'assigns @root_collections to be an array of Grom::Nodes' do
          expect(assigns(:root_collections).first).to be_a(Grom::Node)
        end

        it 'assigns @root_collections to be an array of Grom::Nodes of type Collection' do
          expect(assigns(:root_collections).map(&:type).uniq).to eq(['https://id.parliament.uk/schema/Collection'])
        end
      end

      context 'when unsuccessful' do
        it 'should raise ActionController::RoutingError error' do
          expect { get :show, params: { article_id: 'ccdwcKYM' } }.to raise_error(ActionController::RoutingError, 'Article Not Found')
        end
      end
    end
  end

  describe '#data_check' do
    let(:data_check_methods) do
      [
        {
          route: 'show',
          parameters: { article_id: 'ccdwcKYM' },
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/webarticle_by_id?webarticle_id=ccdwcKYM"
        }
      ]
    end

    it_behaves_like 'a data service request'

    context 'an unavailable data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/foo' }
        request.headers.merge(headers)
      end
      it 'should raise ActionController::UnknownFormat error' do
        expect{ get :show, params: { article_id: 'ccdwcKYM' } }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end
end
