# frozen_string_literal: true

module MetaTagsHelper
  def default_meta_tags
    {
      site: 'YamaNotes',
      reverse: true,
      charset: 'utf-8',
      description: '山手線一周に徒歩で挑戦する人のための記録アプリ',
      keywords: '山手線一周,山手線,徒歩',
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
