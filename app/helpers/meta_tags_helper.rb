# frozen_string_literal: true

module MetaTagsHelper
  def default_meta_tags
    {
      site: 'YamaNotes',
      reverse: true,
      charset: 'utf-8',
      description: t('layouts.meta.description'),
      keywords: t('layouts.meta.keywords'),
      separator: '|',
      og:,
      twitter:
    }
  end

  private

  def og
    {
      site_name: :site,
      title: :title,
      description: :description,
      type: 'website',
      url: request.url,
      image: image_url('ogp.png'),
      local: 'ja-JP'
    }
  end

  def twitter
    {
      card: 'summary_large_image',
      image: image_url('ogp.png'),
      url: request.url
    }
  end
end
