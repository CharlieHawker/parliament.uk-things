require 'rails_helper'

RSpec.describe 'collections/_root_collection' do
  let!(:subcollection) {
    assign(:subcollection,
      double(:subcollection,
        name:        subcollection_name_text,
        description: subcollection_description_text,
        graph_id:    'asdf1234',
      )
    )
  }

  let!(:article) {
    assign(:article,
      double(:article,
        article_title:   article_title_text,
        article_summary: article_summary_text,
        graph_id:        'xoxoxox8'
      )
    )
  }

  let!(:collection) {
    assign(:collection,
      double(:collection,
        name:                 collection_name_text,
        extended_description: collection_extended_description_text,
        subcollections:       [subcollection],
        articles:             [article],
        parents:              []
      )
    )
  }

  let!(:collection_name_text)                 { 'This is a test Collection.' }
  let!(:collection_extended_description_text) { '__This__ is an extended test description of a Collection.' }
  let!(:subcollection_name_text)              { 'This is a test subcollection name' }
  let!(:subcollection_description_text)       { 'This is a test subcollection description' }
  let!(:article_title_text)                   { 'This is a test Title.' }
  let!(:article_summary_text)                 { '**This** is an article summary' }

  before(:each) do
    render partial: "collections/root_collection", locals: { collection: collection }
  end

  context 'collection' do
    context 'converted to HTML' do
      it 'name will render correctly' do
        expect(rendered).to match(/<h1>This is a test Collection.<\/h1>/)
      end

      it 'extended description will render correctly' do
        expect(rendered).to match(/<p><strong>This<\/strong> is an extended test description of a Collection.<\/p>/)
      end
    end

    context 'sanitize' do
      let!(:collection_name_text) { '<script>This is a test Collection name.</script>' }
      let!(:collection_extended_description_text) { '<script>**This** is an extended description</script>' }

      it 'sanitized name will render correctly' do
        expect(rendered).to match(/<h1>This is a test Collection name.<\/h1>/)
      end

      it 'sanitized extended description will render correctly' do
        expect(rendered).to match(/<p><strong>This<\/strong> is an extended description<\/p>/)
      end
    end
  end

  context 'articles' do
    context 'converted to HTML' do
      it 'will render articles' do
        expect(rendered).to match(/<a href="\/articles\/xoxoxox8">This is a test Title.<\/a>/)
      end
    end

    context 'sanitize' do
      let!(:article_title_text) { '<script>This is a test Title.</script>' }
      let!(:article_summary_text) { '<script>__This__ is an article summary</script>' }

      it 'will render the sanitized link to articles' do
        expect(rendered).to match(/<a href="\/articles\/xoxoxox8">This is a test Title.<\/a>/)
      end
    end
  end

  context 'subcollection' do
    context 'converted to HTML' do
      it 'name will render correctly' do
        expect(rendered).to match(/<a href="\/collections\/asdf1234">This is a test subcollection name<\/a>/)
      end

      it 'description will render correctly' do
        expect(rendered).to match(/<p>This is a test subcollection description<\/p>/)
      end
    end

    context 'sanitize' do
      let!(:subcollection_name_text)        { '<script>This is a test subcollection name.</script>' }
      let!(:subcollection_description_text) { '<script>This is a test subcollection description.</script>' }

      it 'name will render correctly' do
        expect(rendered).to match(/<a href="\/collections\/asdf1234">This is a test subcollection name.<\/a>/)
      end

      it 'description will render correctly' do
        expect(rendered).to match(/<p>This is a test subcollection description.<\/p>/)
      end
    end
  end

  context 'headings' do
    it 'displays the correct header for the root collection' do
      expect(rendered).to match(/In this section/)
    end
  end

end
