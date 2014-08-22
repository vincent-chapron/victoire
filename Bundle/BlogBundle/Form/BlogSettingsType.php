<?php
namespace Victoire\Bundle\BlogBundle\Form;

use Symfony\Component\Form\FormBuilderInterface;
use Victoire\Bundle\PageBundle\Entity\BasePage;

/**
 * Edit Blog Type
 */
class BlogSettingsType extends BlogType
{

    /**
     * define form fields
     * @param FormBuilderInterface $builder
     * @param array                $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        parent::buildForm($builder, $options);
        $builder
            ->add('slug', null, array(
                'label' => 'form.page.type.slug.label'
            ))
            ->add('status', 'choice', array(
                'label'   => 'form.page.type.status.label',
                'choices' => array(
                    BasePage::STATUS_DRAFT       => 'form.page.type.status.choice.label.draft',
                    BasePage::STATUS_PUBLISHED   => 'form.page.type.status.choice.label.published',
                    BasePage::STATUS_UNPUBLISHED => 'form.page.type.status.choice.label.unpublished',
                    BasePage::STATUS_SCHEDULED   => 'form.page.type.status.choice.label.scheduled',
                )
            ))
            ->add('publishedAt', null, array(
                'widget'         => 'single_text',
                'datetimepicker' => true
            ));
    }

    /**
     * get form name
     */
    public function getName()
    {
        return 'victoire_blog_settings_type';
    }
}