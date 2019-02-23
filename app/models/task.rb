class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  private

  def validate_name_not_including_comma
    # 名前にカンマが含まれていたら、errorsにエラー内容を格納する
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
