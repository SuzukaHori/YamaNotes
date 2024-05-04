# frozen_string_literal: true

module ApplicationHelper
  def fontawesome_url
    ENV.fetch('FONTAWESOME_URL', nil)
  end

  def default_meta_tags
    {
      site: 'YamaNotes',
      reverse: true,
      charset: 'utf-8',
      description: '山手線一周に徒歩で挑戦する人のための記録アプリ',
      keywords: '山手線一周,山手線,徒歩',
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        image: image_url('ogp.png')
      }
    }
  end
end
